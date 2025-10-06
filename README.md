
# 🌳 monitor-tree-api

API para monitoramento de sensores, leituras e alertas, com autenticação via JWT 🔐.


Documentação Swagger https://green-alert-rm555276.azurewebsites.net/swagger-ui/index.html
---

## 🛢 Banco de Dados

Esta API utiliza **SQL SERVER**.

Configure o arquivo `application.properties` com suas credenciais:

```properties
spring.datasource.url= jdbc:sqlserver://sqlserver-rm??????.database.windows.net:1433;database=greenalertdb;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha
```

---

## Para deploy no Azure

### 1° Registrar provedores necessários 
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Sql


### 2° Rodar o Script 'create-sql-server.ps1'
### 3° Rodar o Script 'deploy-green-alert'

az extension add --name application-insights
chmod +x deploy-green-alert.sh
./deploy-green-alert.sh

### 4° Configurar secrets do github

SPRING_DATASOURCE_URL = jdbc:sqlserver://sqlserver-rm556219.database.windows.net:1433;database=greenalertdb;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
SPRING_DATASOURCE_USERNAME = adm556219
SPRING_DATASOURCE_PASSWORD = Green@Alert

### 5° Rodar a aplicação

---

## 🔐 Autenticação JWT

Para acessar endpoints protegidos, é necessário autenticar-se:

1. Faça um **POST** para `/login` com e-mail e senha.
2. O token retornado deve ser enviado no header **Authorization**:

```http
Authorization: Bearer <token>
```

---

## 🚀 Endpoints

### 1. 🔑 Login

**POST** `http://localhost:8080/login`  
**Body:**
```json
{
  "email": "ana@fiap.com.br",
  "password": "1234"
}
```

---

### 2. 👤 Criar usuário

**POST** `http://localhost:8080/usuarios`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "nome": "Leticia",
  "cpf": "390.533.447-05",
  "telefone": "11999999999",
  "email": "leticia@fiap.com.br",
  "role": "USER",
  "senha": "12356"
}
```

---

### 3. 📋 Listar usuários

**GET** `http://localhost:8080/usuarios`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 4. 🛠 Cadastrar sensor

**POST** `http://localhost:8080/sensores`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "nome": "Sensor de Temperatura",
  "tipo": "TEMPERATURA",
  "localizacao": "Sala 1",
  "dataCriacao": "2025-06-04T21:00:00"
}
```

---

### 5. 🔍 Listar sensores

**GET** `http://localhost:8080/sensores`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 6. 📡 Buscar sensor por ID

**GET** `http://localhost:8080/sensores/{id}`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 7. ✏️ Atualizar sensor

**PUT** `http://localhost:8080/sensores/{id}`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "nome": "Sensor Atualizado",
  "tipo": "UMIDADE",
  "localizacao": "Estufa 3",
  "dataCriacao": "2025-06-04T21:00:00"
}
```

---

### 8. 🗑 Deletar sensor

**DELETE** `http://localhost:8080/sensores/{id}`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 9. 📝 Criar leitura

**POST** `http://localhost:8080/leituras`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "valor": 25.5,
  "unidade": "CELSIUS",
  "dataHora": "2025-06-04T12:00:00",
  "sensorId": 1
}
```

---

### 10. 📊 Listar leituras

**GET** `http://localhost:8080/leituras`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 11. 🔍 Buscar leitura por ID

**GET** `http://localhost:8080/leituras/{id}`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 12. ✏️ Atualizar leitura

**PUT** `http://localhost:8080/leituras/{id}`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "valor": 30.1,
  "unidade": "CELCIUS",
  "dataHora": "2025-06-04T15:00:00",
  "sensorId": 1
}
```

---

### 13. 🗑 Deletar leitura

**DELETE** `http://localhost:8080/leituras/{id}`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 14. Criar chamado

**POST /chamados**

```json
{
  "alertaId": 1,
  "titulo": "Verificar Sensor",
  "descricao": "Sensor apresentou falha.",
  "status": "ABERTO",
  "tipo": "DRONES",
  "dataHoraAbertura": "2025-06-07T10:00:00"
}
```

---

### 15. Listar chamados (paginado)

**GET /chamados?page=0&size=10**

---

### 16. Buscar chamado por ID

**GET /chamados/{id}**

---

### 17. Atualizar chamado

**PUT /chamados/{id}**

```json
{
  "alertaId": 1,
  "titulo": "Verificar Sensor URGENTE",
  "descricao": "Sensor apresentou falha crítica.",
  "status": "RESOLVIDO",
  "tipo": "ESPECIALISTA",
  "dataHoraAbertura": "2025-06-07T10:00:00",
  "dataHoraFechamento": "2025-06-07T12:00:00"
}
```

---

### 18. Deletar chamado

**DELETE /chamados/{id}**

---

## 🏷️ Valores possíveis para `tipo`

- `DRONES`
- `ESPECIALISTA`
- `BOMBEIROS`
- `POLICIA`

---

## ℹ️ Observações

- O campo `status` deve ser um valor válido do enum `ChamadoStatus` (ex: `ABERTO`, `PENDENTE`, `RESOLVIDO`).
- O campo `tipo` deve ser um dos valores acima.
- Datas devem estar no formato ISO, ex: `"2025-06-07T10:00:00"`.

---
Authorization: Bearer <token>
```

---
