# 🌳 Monitor Tree API

API para monitoramento de sensores, leituras e alertas, com autenticação via JWT 🔐.

## 🌐 Link de Deploy

Acesse a aplicação em produção: [http://172.191.46.215:8080](http://172.191.46.215:8080)

## 🎥 Link do Youtube

Vídeo Demonstrativo: [https://youtu.be/YJ3WQ0sZKOA](https://youtu.be/YJ3WQ0sZKOA)

## 📑 Documentação Swagger

[http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)

---

## 🛢 Banco de Dados

Esta API utiliza **MySQL** 🐬.

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

### 🔑 Login

**POST** `/login`

```json
{
  "email": "ana@fiap.com.br",
  "password": "1234"
}
```

---

### 👤 Criar Usuário

**POST** `/usuarios`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

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

### 📋 Listar Usuários

**GET** `/usuarios`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### 🛠 Cadastrar Sensor

**POST** `/sensores`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "nome": "Sensor de Temperatura",
  "tipo": "TEMPERATURA",
  "localizacao": "Sala 1",
  "dataCriacao": "2025-06-04T21:00:00"
}
```

---

### 📡 Buscar Sensor por ID

**GET** `/sensores/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### ✏️ Atualizar Sensor

**PUT** `/sensores/{id}`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "nome": "Sensor Atualizado",
  "tipo": "UMIDADE",
  "localizacao": "Estufa 3",
  "dataCriacao": "2025-06-04T21:00:00"
}
```

---

### 🗑 Deletar Sensor

**DELETE** `/sensores/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### 📝 Criar Leitura

**POST** `/leituras`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "valor": 25.5,
  "unidade": "CELSIUS",
  "dataHora": "2025-06-04T12:00:00",
  "sensorId": 1
}
```

---

### 📊 Listar Leituras

**GET** `/leituras`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### 🔍 Buscar Leitura por ID

**GET** `/leituras/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### ✏️ Atualizar Leitura

**PUT** `/leituras/{id}`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "valor": 30.1,
  "unidade": "CELCIUS",
  "dataHora": "2025-06-04T15:00:00",
  "sensorId": 1
}
```

---

### 🗑 Deletar Leitura

**DELETE** `/leituras/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### 🚨 Criar Alerta

**POST** `/alertas`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

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

### 📄 Listar Alertas

**GET** `/alertas`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### 🔍 Buscar Alerta por ID

**GET** `/alertas/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

### ✏️ Atualizar Alerta

**PUT** `/alertas/{id}`

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

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

### 🗑 Deletar Alerta

**DELETE** `/alertas/{id}`

**Headers:**
```http
Authorization: Bearer <token>
```

---

## 📞 Chamados

### 📌 Criar Chamado

**POST** `/chamados`

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

### 📄 Listar Chamados (Paginado)

**GET** `/chamados?page=0&size=10`

---

### 🔍 Buscar Chamado por ID

**GET** `/chamados/{id}`

---

### ✏️ Atualizar Chamado

**PUT** `/chamados/{id}`

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

### 🗑 Deletar Chamado

**DELETE** `/chamados/{id}`

---

## 🏷️ Valores Possíveis para `tipo`

- `DRONES`
- `ESPECIALISTA`
- `BOMBEIROS`
- `POLICIA`

---

## ℹ️ Observações

- O campo `status` deve ser um valor válido do enum `ChamadoStatus` (`ABERTO`, `PENDENTE`, `RESOLVIDO`).
- O campo `tipo` deve ser um dos valores listados acima.
- Datas devem estar no formato ISO: `"2025-06-07T10:00:00"`.

---
