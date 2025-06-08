
# 🌳 monitor-tree-api

API para monitoramento de sensores, leituras e alertas, com autenticação via JWT 🔐.


Documentação Swagger http://localhost:8080/swagger-ui/index.html
---

## 🛢 Banco de Dados

Esta API utiliza **MySQL** 🐬.

Configure o arquivo `application.properties` com suas credenciais:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/monitor_tree
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

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

### 14. 🚨 Criar alerta

**POST** `http://localhost:8080/alertas`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "descricao": "Temperatura muito alta",
  "tipoAlerta": "TEMPERATURA",
  "status": "ATIVO",
  "dataHora": "2025-06-04T13:00:00",
  "sensorId": 1
}
```

---

### 15. 📄 Listar alertas

**GET** `http://localhost:8080/alertas`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 16. 🔍 Buscar alerta por ID

**GET** `http://localhost:8080/alertas/{id}`  
**Headers:**
```
Authorization: Bearer <token>
```

---

### 17. ✏️ Atualizar alerta

**PUT** `http://localhost:8080/alertas/{id}`  
**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Body:**
```json
{
  "descricao": "Alerta atualizado",
  "tipoAlerta": "UMIDADE",
  "status": "RESOLVIDO",
  "dataHora": "2025-06-04T13:30:00",
  "sensorId": 1
}
```

---

### 18. 🗑 Deletar alerta

**DELETE** `http://localhost:8080/alertas/{id}`  
**Headers:**


# 📞 Chamados

### 1. Criar chamado

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

### 2. Listar chamados (paginado)

**GET /chamados?page=0&size=10**

---

### 3. Buscar chamado por ID

**GET /chamados/{id}**

---

### 4. Atualizar chamado

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

### 5. Deletar chamado

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
