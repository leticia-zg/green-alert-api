$RG = "rg-green-alert"
$LOCATION = "brazilsouth"
$SERVER_NAME = "sqlserver-rm555276"
$USERNAME = "adm555276"
$PASSWORD = "Green@Alert"  
$DBNAME = "greenalertdb"

# ====== CRIA RG / SERVER / DB ======
az group create --name $RG --location $LOCATION
az sql server create -l $LOCATION -g $RG -n $SERVER_NAME -u $USERNAME -p $PASSWORD --enable-public-network true
az sql db create -g $RG -s $SERVER_NAME -n $DBNAME --service-objective Basic --backup-storage-redundancy Local --zone-redundant false


$MYIP = (Invoke-RestMethod -Uri "https://api.ipify.org").ToString()
az sql server firewall-rule create -g $RG -s $SERVER_NAME -n allow-my-ip --start-ip-address $MYIP --end-ip-address $MYIP
# permitir serviços do Azure
az sql server firewall-rule create -g $RG -s $SERVER_NAME -n allow-azure --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

$ServerFqdn   = "$SERVER_NAME.database.windows.net"  
$DbName       = $DBNAME                              
$SqlAdminUser = $USERNAME                            
$PlainAdminPwd= $PASSWORD                            

# (se faltar o módulo SqlServer, instala rapidamente)
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
  try { Install-Module SqlServer -Scope CurrentUser -Force -AllowClobber } catch {}
  Import-Module SqlServer -ErrorAction SilentlyContinue
}

Invoke-Sqlcmd -ServerInstance $ServerFqdn `
              -Database $DbName `
              -Username $SqlAdminUser `
              -Password $PlainAdminPwd `
              -Query @"
-- 1) Usuarios
IF OBJECT_ID('dbo.usuarios','U') IS NULL
BEGIN
  CREATE TABLE dbo.usuarios (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    nome          NVARCHAR(120)      NOT NULL,
    cpf           VARCHAR(14)        NOT NULL,
    telefone      VARCHAR(20)        NULL,
    email         NVARCHAR(180)      NOT NULL,
    role          VARCHAR(30)        NOT NULL,
    senha         NVARCHAR(255)      NOT NULL,
    criado_em     DATETIME2          NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_usuarios_cpf   UNIQUE (cpf),
    CONSTRAINT UQ_usuarios_email UNIQUE (email)
  );
END;

-- 2) Sensores
IF OBJECT_ID('dbo.sensores','U') IS NULL
BEGIN
  CREATE TABLE dbo.sensores (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    nome          NVARCHAR(120)      NOT NULL,
    tipo          VARCHAR(40)        NOT NULL,   -- TEMPERATURA | UMIDADE | FUMACA | PRESSAO | OUTRO
    localizacao   NVARCHAR(120)      NULL,
    dataCriacao   DATETIME2          NOT NULL
  );
  ALTER TABLE dbo.sensores WITH NOCHECK
    ADD CONSTRAINT CK_sensores_tipo CHECK (tipo IN ('TEMPERATURA','UMIDADE','FUMACA','PRESSAO','OUTRO'));
END;

-- 3) Leituras
IF OBJECT_ID('dbo.leituras','U') IS NULL
BEGIN
  CREATE TABLE dbo.leituras (
    id            BIGINT IDENTITY(1,1) PRIMARY KEY,
    valor         DECIMAL(10,4)      NOT NULL,
    unidade       VARCHAR(30)        NOT NULL,
    dataHora      DATETIME2          NOT NULL,
    sensorId      INT                NOT NULL,
    CONSTRAINT FK_leituras_sensor
      FOREIGN KEY (sensorId) REFERENCES dbo.sensores(id)
        ON DELETE CASCADE
  );
  CREATE INDEX IX_leituras_sensorId ON dbo.leituras(sensorId);
  CREATE INDEX IX_leituras_dataHora ON dbo.leituras(dataHora);
END;

-- 4) Alertas
IF OBJECT_ID('dbo.alertas','U') IS NULL
BEGIN
  CREATE TABLE dbo.alertas (
    id            BIGINT IDENTITY(1,1) PRIMARY KEY,
    descricao     NVARCHAR(255)      NOT NULL,
    tipoAlerta    VARCHAR(40)        NOT NULL,   -- TEMPERATURA | UMIDADE | FUMACA | PRESSAO | OUTRO
    status        VARCHAR(20)        NOT NULL,   -- ATIVO | RESOLVIDO | PENDENTE
    dataHora      DATETIME2          NOT NULL,
    sensorId      INT                NOT NULL,
    CONSTRAINT FK_alertas_sensor
      FOREIGN KEY (sensorId) REFERENCES dbo.sensores(id)
        ON DELETE CASCADE,
    CONSTRAINT CK_alertas_status CHECK (status IN ('ATIVO','RESOLVIDO','PENDENTE'))
  );
  ALTER TABLE dbo.alertas WITH NOCHECK
    ADD CONSTRAINT CK_alertas_tipo CHECK (tipoAlerta IN ('TEMPERATURA','UMIDADE','FUMACA','PRESSAO','OUTRO'));
  CREATE INDEX IX_alertas_sensorId ON dbo.alertas(sensorId);
  CREATE INDEX IX_alertas_status   ON dbo.alertas(status);
END;

-- 5) Chamados
IF OBJECT_ID('dbo.chamados','U') IS NULL
BEGIN
  CREATE TABLE dbo.chamados (
    id                  BIGINT IDENTITY(1,1) PRIMARY KEY,
    alertaId            BIGINT             NOT NULL,
    titulo              NVARCHAR(150)      NOT NULL,
    descricao           NVARCHAR(500)      NULL,
    status              VARCHAR(20)        NOT NULL,   -- ABERTO | PENDENTE | RESOLVIDO
    tipo                VARCHAR(20)        NOT NULL,   -- DRONES | ESPECIALISTA | BOMBEIROS | POLICIA
    dataHoraAbertura    DATETIME2          NOT NULL,
    dataHoraFechamento  DATETIME2          NULL,
    CONSTRAINT FK_chamados_alerta
      FOREIGN KEY (alertaId) REFERENCES dbo.alertas(id)
        ON DELETE CASCADE,
    CONSTRAINT CK_chamados_status CHECK (status IN ('ABERTO','PENDENTE','RESOLVIDO')),
    CONSTRAINT CK_chamados_tipo   CHECK (tipo   IN ('DRONES','ESPECIALISTA','BOMBEIROS','POLICIA'))
  );
  CREATE INDEX IX_chamados_alertaId ON dbo.chamados(alertaId);
  CREATE INDEX IX_chamados_status   ON dbo.chamados(status);
END;
"@
