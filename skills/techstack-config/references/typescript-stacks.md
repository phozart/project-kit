# TypeScript Stack Configurations

Common patterns and configurations for TypeScript/JavaScript-based stacks.

## React + Vite Stack

**Typical Dependencies**:
- react, react-dom
- vite
- typescript
- @vitejs/plugin-react
- vitest (testing)
- @testing-library/react

**Commands**:
```yaml
build: vite build
test: vitest run
lint: eslint src/ --ext ts,tsx && prettier --check src/
dev: vite --host 0.0.0.0 --port 3000
```

**Project Structure**:
```
src/
  main.tsx
  App.tsx
  components/
  hooks/
  pages/
  services/
  types/
  utils/
tests/
vite.config.ts
tsconfig.json
```

## Next.js Stack

**Typical Dependencies**:
- next
- react, react-dom
- typescript
- @types/node, @types/react

**Commands**:
```yaml
build: next build
test: jest
lint: eslint . --ext ts,tsx && prettier --check .
dev: next dev
```

**Project Structure**:
```
src/
  app/ (App Router)
    page.tsx
    layout.tsx
  components/
  lib/
  types/
next.config.js
tsconfig.json
```

## Express Stack

**Typical Dependencies**:
- express
- typescript
- @types/express
- @types/node
- ts-node-dev (dev)
- jest
- supertest (testing)

**Commands**:
```yaml
build: tsc
test: jest
lint: eslint src/ --ext ts && prettier --check src/
dev: ts-node-dev --respawn src/index.ts
```

**Project Structure**:
```
src/
  index.ts
  routes/
  controllers/
  middleware/
  models/
  services/
  types/
tests/
tsconfig.json
```

## NestJS Stack

**Typical Dependencies**:
- @nestjs/core
- @nestjs/common
- @nestjs/platform-express
- typescript
- jest
- @nestjs/testing

**Commands**:
```yaml
build: nest build
test: jest
lint: eslint "{src,apps,libs,test}/**/*.ts" && prettier --check .
dev: nest start --watch
```

**Project Structure**:
```
src/
  main.ts
  app.module.ts
  modules/
    <feature>/
      <feature>.controller.ts
      <feature>.service.ts
      <feature>.module.ts
nest-cli.json
tsconfig.json
```

## Common TypeScript Tooling

**Linting & Formatting**:
- ESLint with @typescript-eslint
- Prettier
- typescript (type checking)

**Testing**:
- vitest (modern, Vite-based)
- jest (traditional)
- @testing-library/react (React testing)
- supertest (API testing)

**Build Tools**:
- vite (fast, modern)
- webpack (traditional)
- turbopack (Next.js)
- esbuild (super fast)

**Common tsconfig.json options**:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["ES2020", "DOM"],
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "bundler"
  }
}
```
