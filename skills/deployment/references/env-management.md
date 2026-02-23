# Environment Management

Patterns for managing configuration and secrets across environments.

## Environment Variables

### Loading Environment Variables

**Node.js with dotenv:**
```javascript
// Load from .env file
require('dotenv').config();

const config = {
  port: process.env.PORT || 3000,
  dbUrl: process.env.DATABASE_URL,
  apiKey: process.env.API_KEY
};
```

**Python with python-dotenv:**
```python
from dotenv import load_dotenv
import os

load_dotenv()

config = {
    'port': int(os.getenv('PORT', 3000)),
    'db_url': os.getenv('DATABASE_URL'),
    'api_key': os.getenv('API_KEY')
}
```

**Java with Spring Boot:**
```properties
# application.properties
server.port=${PORT:8080}
spring.datasource.url=${DATABASE_URL}
api.key=${API_KEY}
```

### Configuration Validation

```javascript
// Validate required variables at startup
const requiredEnvVars = ['DATABASE_URL', 'API_KEY', 'JWT_SECRET'];

requiredEnvVars.forEach(varName => {
  if (!process.env[varName]) {
    throw new Error(`Missing required environment variable: ${varName}`);
  }
});
```

## Environment-Specific Configuration

### Development Environment
```bash
# .env.development
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://localhost:5432/myapp_dev
API_BASE_URL=http://localhost:8080
LOG_LEVEL=debug
ENABLE_MOCK_DATA=true
```

### Staging Environment
```bash
# .env.staging
NODE_ENV=staging
PORT=3000
DATABASE_URL=postgresql://staging-db:5432/myapp_staging
API_BASE_URL=https://api-staging.example.com
LOG_LEVEL=info
ENABLE_MOCK_DATA=false
```

### Production Environment
```bash
# .env.production
NODE_ENV=production
PORT=8080
DATABASE_URL=postgresql://prod-db:5432/myapp_prod
API_BASE_URL=https://api.example.com
LOG_LEVEL=warn
ENABLE_MOCK_DATA=false
```

## Secrets Management

### AWS Secrets Manager

```javascript
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

async function getSecret(secretName) {
  const data = await secretsManager.getSecretValue({
    SecretId: secretName
  }).promise();

  return JSON.parse(data.SecretString);
}

// Usage
const dbCreds = await getSecret('prod/db/credentials');
```

### HashiCorp Vault

```javascript
const vault = require('node-vault')({
  endpoint: process.env.VAULT_ADDR,
  token: process.env.VAULT_TOKEN
});

async function getSecret(path) {
  const result = await vault.read(path);
  return result.data;
}

// Usage
const apiKey = await getSecret('secret/data/api-key');
```

### Azure Key Vault

```javascript
const { SecretClient } = require('@azure/keyvault-secrets');
const { DefaultAzureCredential } = require('@azure/identity');

const client = new SecretClient(
  process.env.AZURE_KEYVAULT_URL,
  new DefaultAzureCredential()
);

async function getSecret(secretName) {
  const secret = await client.getSecret(secretName);
  return secret.value;
}
```

## Configuration Best Practices

### Never Commit Secrets
```gitignore
# .gitignore
.env
.env.*
!.env.example
*.pem
*.key
secrets/
```

### Provide Example Configuration
```bash
# .env.example
# Copy to .env and fill in values
DATABASE_URL=postgresql://localhost:5432/myapp
API_KEY=your_api_key_here
JWT_SECRET=your_jwt_secret_here
```

### Type-Safe Configuration (TypeScript)
```typescript
interface Config {
  port: number;
  databaseUrl: string;
  apiKey: string;
  jwtSecret: string;
}

function loadConfig(): Config {
  const config = {
    port: parseInt(process.env.PORT || '3000'),
    databaseUrl: process.env.DATABASE_URL!,
    apiKey: process.env.API_KEY!,
    jwtSecret: process.env.JWT_SECRET!
  };

  // Validate
  if (!config.databaseUrl) throw new Error('DATABASE_URL required');
  if (!config.apiKey) throw new Error('API_KEY required');
  if (!config.jwtSecret) throw new Error('JWT_SECRET required');

  return config;
}

export const config = loadConfig();
```

## Feature Flags

```javascript
const features = {
  newDashboard: process.env.FEATURE_NEW_DASHBOARD === 'true',
  betaFeatures: process.env.FEATURE_BETA === 'true',
  maintenance: process.env.MAINTENANCE_MODE === 'true'
};

// Usage
if (features.newDashboard) {
  // Show new dashboard
} else {
  // Show old dashboard
}
```

## Database Connection Strings

### PostgreSQL
```bash
DATABASE_URL=postgresql://username:password@hostname:5432/database?sslmode=require
```

### MongoDB
```bash
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/database?retryWrites=true
```

### Redis
```bash
REDIS_URL=redis://username:password@hostname:6379
```
