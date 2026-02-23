---
name: deployment
description: Docker, CI/CD, and environment management for deployment
---

# Deployment Skill

Deployment patterns and practices covering Docker containerization, CI/CD pipelines, and environment management for Phase 9 release preparation.

## Overview

This skill provides deployment knowledge for:
- **Docker Containerization** — Multi-stage builds, security, optimization
- **CI/CD Pipelines** — GitHub Actions, GitLab CI patterns
- **Environment Management** — Configuration, secrets, environment-specific settings

## When to Use

Use this skill when:
- Entering Phase 9 release preparation
- User asks to "prepare deployment" or "configure CI/CD"
- Setting up Docker containers
- Configuring build and deploy pipelines
- Managing environment configuration

## Docker Containerization

### Multi-Stage Builds
Multi-stage builds reduce final image size by separating build and runtime dependencies.

**Benefits:**
- Smaller production images
- Faster deployment
- Reduced attack surface
- Build tools not in production image

See: `references/docker-patterns.md`

### Security Best Practices
- Run as non-root user
- Scan for vulnerabilities
- Minimal base images (Alpine, Distroless)
- No secrets in image layers
- Use .dockerignore

### Image Optimization
- Layer caching for faster builds
- Copy dependencies before source code
- Remove unnecessary files
- Combine RUN commands
- Use specific base image tags (not latest)

## CI/CD Pipeline Configuration

### Pipeline Stages
Typical pipeline stages for continuous integration and deployment:

1. **Build** — Compile code, install dependencies
2. **Test** — Run unit, integration, e2e tests
3. **Lint** — Code quality checks
4. **Security Scan** — Dependency and container scanning
5. **Build Image** — Create Docker image
6. **Push Image** — Push to container registry
7. **Deploy** — Deploy to target environment

See: `references/cicd-patterns.md`

### Testing in CI/CD
- Unit tests in build stage (fast feedback)
- Integration tests with test database
- E2E tests against deployed preview environment
- Parallel test execution for speed
- Test result reporting

### Deployment Strategies

**Rolling Deployment:**
- Gradually replace old version with new
- Zero downtime
- Easy rollback

**Blue-Green Deployment:**
- Two identical environments (blue and green)
- Switch traffic between them
- Instant rollback

**Canary Deployment:**
- Deploy to small subset of users first
- Monitor metrics
- Gradual rollout

## Environment Management

### Environment Configuration
Applications typically have multiple environments:
- **Development** — Local development
- **Staging/QA** — Pre-production testing
- **Production** — Live system

Each environment has different configuration:
- Database connections
- API endpoints
- Feature flags
- Resource limits
- Logging levels

See: `references/env-management.md`

### Configuration Best Practices
- Never commit secrets to version control
- Use environment variables
- Separate config from code
- Validate configuration at startup
- Document required variables

### Secrets Management
- Use secrets manager (AWS Secrets Manager, HashiCorp Vault, Azure Key Vault)
- Encrypt secrets at rest
- Rotate secrets regularly
- Limit access to secrets
- Audit secret access
- Never log secrets

## Deployment Checklist

### Pre-Deployment
- [ ] All tests passing in CI/CD
- [ ] QA sign-off received
- [ ] Security scan passed
- [ ] Database migrations prepared
- [ ] Rollback plan documented
- [ ] Monitoring and alerting configured
- [ ] Documentation updated

### Deployment
- [ ] Backup production database
- [ ] Run database migrations
- [ ] Deploy new version
- [ ] Verify health checks
- [ ] Monitor error rates
- [ ] Verify critical user journeys

### Post-Deployment
- [ ] Monitor metrics for anomalies
- [ ] Check logs for errors
- [ ] Verify database migrations succeeded
- [ ] Test critical functionality
- [ ] Update status page
- [ ] Document deployment outcome

## Infrastructure as Code

### Benefits
- Version controlled infrastructure
- Repeatable deployments
- Environment parity
- Documented infrastructure

### Tools
- Terraform — Cloud infrastructure
- Kubernetes manifests — Container orchestration
- Docker Compose — Multi-container local development
- Helm — Kubernetes package manager

## Monitoring and Observability

### Health Checks
Implement health check endpoints:
- `/health` — Basic liveness check
- `/health/ready` — Readiness check (dependencies available)
- `/health/live` — Liveness check (application running)

### Logging
- Structured logging (JSON)
- Log aggregation (ELK, Splunk, CloudWatch)
- Correlation IDs for request tracing
- Appropriate log levels
- No sensitive data in logs

### Metrics
- Application metrics (requests, errors, latency)
- Business metrics (signups, transactions)
- Infrastructure metrics (CPU, memory, disk)
- Dashboards for visualization
- Alerting on thresholds

### Distributed Tracing
- Trace requests across services
- Identify bottlenecks
- Debug production issues
- Tools: Jaeger, Zipkin, AWS X-Ray

## Rollback Strategy

### When to Rollback
- Error rate spike
- Critical functionality broken
- Performance degradation
- Data corruption

### Rollback Process
1. Identify issue
2. Execute rollback (redeploy previous version)
3. Verify rollback successful
4. Communicate to stakeholders
5. Investigate root cause
6. Fix and redeploy

### Database Rollback
- Backward-compatible migrations
- Data backups before deployment
- Test rollback procedure
- Consider data changes since deployment

## Deployment Documentation

### Required Documentation
- **Deployment Guide** — Step-by-step deployment instructions
- **Runbook** — Operational procedures for common issues
- **Architecture Diagram** — System architecture and data flow
- **Configuration Guide** — Environment variables and configuration options
- **Disaster Recovery Plan** — Backup and recovery procedures

## References

Detailed patterns and examples:
- `references/docker-patterns.md` — Multi-stage builds, security, optimization
- `references/cicd-patterns.md` — GitHub Actions, GitLab CI patterns
- `references/env-management.md` — Environment variables, secrets, config per environment
