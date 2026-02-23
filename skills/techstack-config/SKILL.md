---
name: techstack-config
description: Guided interactive techstack selection with human-driven technology decisions
---

# Techstack Configuration Skill

Guides humans through interactive technology selection for each layer of the application stack. CRITICAL: Technology decisions are NEVER made by agents — this skill presents options and the human chooses.

## When to Use

- During project initialization
- User explicitly says "configure techstack" or "select technologies"
- Updating or changing technology choices in existing projects
- Need to generate build/test/lint commands for selected stack

## What This Skill Does

This skill provides guided, layer-by-layer technology selection through interactive prompts. After selection, it generates appropriate build, test, lint, and dev commands for the chosen stack.

## Process

### 1. Frontend Layer Selection

**Prompt**: "Select frontend framework (or skip if not applicable):"

Options:
- **React** - Component-based UI library with rich ecosystem
- **Next.js** - React framework with SSR/SSG capabilities
- **Vue** - Progressive framework with gentle learning curve
- **Angular** - Full-featured framework with TypeScript
- **Svelte** - Compile-time framework with minimal runtime
- **Vanilla JS** - No framework, plain JavaScript
- **None** - No frontend (API-only, CLI, etc.)

After selection, ask about:
- State management (Redux, Zustand, Pinia, NgRx, etc.)
- UI component library (if any)
- Build tool preference (Vite, Webpack, Turbopack, esbuild)

### 2. Backend Layer Selection

**Prompt**: "Select backend framework:"

Options:
- **Spring Boot (Java)** - Enterprise Java framework
- **FastAPI (Python)** - Modern async Python framework
- **Django (Python)** - Batteries-included Python framework
- **Express (Node.js)** - Minimalist Node.js framework
- **NestJS (Node.js)** - TypeScript-first enterprise framework
- **Flask (Python)** - Lightweight Python framework
- **Quarkus (Java)** - Kubernetes-native Java framework
- **Go (Standard Library)** - Native Go HTTP services
- **Other** - Specify custom framework

After selection, ask about:
- ORM/database library preference
- API style (REST, GraphQL, gRPC)
- Validation library

### 3. Data Layer Selection

**Prompt**: "Select data storage and processing technologies:"

For **Database**, present:
- **PostgreSQL** - Advanced open-source relational DB
- **MySQL/MariaDB** - Popular relational DB
- **MongoDB** - Document-oriented NoSQL
- **Redis** - In-memory data store
- **Cassandra** - Wide-column distributed DB
- **DynamoDB** - AWS managed NoSQL
- **Other** - Specify custom database

For **Data Processing** (if applicable):
- **Databricks** - Unified analytics platform
- **Snowflake** - Cloud data warehouse
- **BigQuery** - Google Cloud data warehouse
- **Apache Spark** - Distributed processing
- **dbt** - Data transformation tool
- **Apache Airflow** - Workflow orchestration
- **Prefect** - Modern workflow orchestration
- **None** - No special data processing needed

### 4. Infrastructure Layer Selection

**Prompt**: "Select infrastructure and deployment target:"

Options:
- **AWS** - Amazon Web Services
- **Google Cloud Platform** - GCP services
- **Azure** - Microsoft Azure
- **Docker + Docker Compose** - Containerization for local/simple deployments
- **Kubernetes** - Container orchestration
- **Serverless (Lambda/Cloud Functions)** - Function-as-a-service
- **Traditional VPS** - Virtual private server
- **Local/On-Premise** - Self-hosted infrastructure

Ask about:
- IaC tool (Terraform, CloudFormation, Pulumi, CDK, none)
- CI/CD platform (GitHub Actions, GitLab CI, Jenkins, CircleCI, none)

### 5. Authentication Layer Selection

**Prompt**: "Select authentication approach:"

Options:
- **OAuth 2.0 / OIDC** - Standard protocol with provider (Auth0, Okta, Cognito, Keycloak)
- **JWT** - Custom JWT implementation
- **Session-based** - Traditional server sessions
- **Firebase Auth** - Firebase authentication service
- **None** - No authentication needed
- **Other** - Specify custom approach

### 6. API Documentation/Contract

**Prompt**: "Select API documentation approach:"

Options:
- **OpenAPI/Swagger** - REST API specification
- **GraphQL Schema** - GraphQL type system
- **gRPC/Protobuf** - Protocol buffers
- **AsyncAPI** - Event-driven/async API spec
- **None** - No formal API spec

### 7. Generate Commands

Based on selections, generate commands for:

**Build**:
- Frontend build command (e.g., `npm run build`, `vite build`)
- Backend build command (e.g., `mvn package`, `pip install -r requirements.txt`)

**Test**:
- Unit test command (e.g., `npm test`, `pytest`, `mvn test`)
- Integration test command
- E2E test command (if applicable)

**Lint**:
- Frontend lint (e.g., `eslint`, `prettier`)
- Backend lint (e.g., `pylint`, `checkstyle`, `golangci-lint`)

**Dev**:
- Frontend dev server (e.g., `npm run dev`, `vite`)
- Backend dev server (e.g., `mvn spring-boot:run`, `uvicorn main:app --reload`)

See references for stack-specific configurations and common patterns.

## Output Format

Return configuration as YAML to be inserted into project.config.yaml:

```yaml
stack:
  frontend:
    framework: <selected-framework>
    state_management: <if-applicable>
    ui_library: <if-applicable>
    build_tool: <selected-tool>
  backend:
    framework: <selected-framework>
    language: <language>
    orm: <if-applicable>
    api_style: <REST|GraphQL|gRPC>
  data:
    database: <selected-db>
    processing: <if-applicable>
  infrastructure:
    platform: <selected-platform>
    iac: <if-applicable>
    cicd: <selected-platform>
  auth:
    method: <selected-method>
    provider: <if-applicable>
  api:
    specification: <selected-spec>

commands:
  build:
    frontend: <command>
    backend: <command>
  test:
    unit: <command>
    integration: <command>
    e2e: <command>
  lint:
    frontend: <command>
    backend: <command>
  dev:
    frontend: <command>
    backend: <command>
```

## References

- [Python Stack Configurations](./references/python-stacks.md)
- [TypeScript Stack Configurations](./references/typescript-stacks.md)
- [Java Stack Configurations](./references/java-stacks.md)
- [Data Engineering Stack Configurations](./references/data-engineering-stacks.md)
