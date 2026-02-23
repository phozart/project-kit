# Deployment Configuration: [PROJECT_NAME]

**Date:** [DATE]
**Version:** [VERSION]
**Author:** [AUTHOR]

## Deployment Strategy

**Type:** [BLUE_GREEN|ROLLING|CANARY|RECREATE]

**Rationale:** [RATIONALE]

## CI/CD Pipeline

### Pipeline Overview
[PIPELINE_OVERVIEW]

### Stages

#### Stage 1: Build
- **Trigger:** [TRIGGER]
- **Actions:**
  - [ACTION_1]
  - [ACTION_2]
- **Artifacts:** [ARTIFACTS]
- **Duration:** [DURATION]

#### Stage 2: Test
- **Actions:**
  - [ACTION_1]
  - [ACTION_2]
- **Coverage Requirements:** [PERCENTAGE]%
- **Duration:** [DURATION]

#### Stage 3: Security Scan
- **Tools:**
  - [TOOL_1]
  - [TOOL_2]
- **Gate:** [GATE_CRITERIA]

#### Stage 4: Deploy to Staging
- **Method:** [METHOD]
- **Actions:**
  - [ACTION_1]
  - [ACTION_2]
- **Smoke Tests:** [YES|NO]

#### Stage 5: Deploy to Production
- **Approval Required:** [YES|NO]
- **Method:** [METHOD]
- **Actions:**
  - [ACTION_1]
  - [ACTION_2]
- **Rollback Strategy:** [STRATEGY]

### Pipeline Configuration

```yaml
# [CI_TOOL] Configuration
pipeline:
  name: [PIPELINE_NAME]
  trigger: [TRIGGER_CONFIG]
  stages:
    - stage: [STAGE_NAME]
      jobs:
        - job: [JOB_NAME]
          steps:
            - [STEP_1]
            - [STEP_2]
```

## Environment Configuration

### Development

**Deployment Method:** [METHOD]

**Environment Variables:**
```
[VAR_1]=[VALUE]
[VAR_2]=[VALUE]
[VAR_3]=[VALUE]
```

**Configuration Files:**
- [CONFIG_FILE_1]
- [CONFIG_FILE_2]

---

### Staging

**Deployment Method:** [METHOD]

**Environment Variables:**
```
[VAR_1]=[VALUE]
[VAR_2]=[VALUE]
[VAR_3]=[VALUE]
```

**Configuration Files:**
- [CONFIG_FILE_1]
- [CONFIG_FILE_2]

**Post-Deployment Tests:**
- [TEST_1]
- [TEST_2]

---

### Production

**Deployment Method:** [METHOD]

**Environment Variables:**
```
[VAR_1]=[VALUE]
[VAR_2]=[VALUE]
[VAR_3]=[VALUE]
```

**Configuration Files:**
- [CONFIG_FILE_1]
- [CONFIG_FILE_2]

**Pre-Deployment Checklist:**
- [ ] [CHECK_1]
- [ ] [CHECK_2]
- [ ] [CHECK_3]

**Post-Deployment Tasks:**
- [TASK_1]
- [TASK_2]

## Container Configuration

### Dockerfile
```dockerfile
FROM [BASE_IMAGE]
WORKDIR [WORKDIR]
COPY [SOURCE] [DEST]
RUN [COMMAND]
EXPOSE [PORT]
CMD [COMMAND]
```

### Container Resources
- **CPU Limit:** [CPU_LIMIT]
- **Memory Limit:** [MEMORY_LIMIT]
- **CPU Request:** [CPU_REQUEST]
- **Memory Request:** [MEMORY_REQUEST]

## Deployment Artifacts

### Build Artifacts
- [ARTIFACT_1]
- [ARTIFACT_2]

### Configuration Artifacts
- [CONFIG_1]
- [CONFIG_2]

### Database Migrations
- **Migration Tool:** [TOOL]
- **Execution:** [AUTOMATIC|MANUAL]
- **Rollback:** [ROLLBACK_STRATEGY]

## Health Checks

### Liveness Probe
```yaml
livenessProbe:
  httpGet:
    path: [PATH]
    port: [PORT]
  initialDelaySeconds: [SECONDS]
  periodSeconds: [SECONDS]
```

### Readiness Probe
```yaml
readinessProbe:
  httpGet:
    path: [PATH]
    port: [PORT]
  initialDelaySeconds: [SECONDS]
  periodSeconds: [SECONDS]
```

## Scaling Configuration

### Auto-scaling Rules
- **Metric:** [METRIC]
- **Target:** [TARGET_VALUE]
- **Scale Up:** [SCALE_UP_POLICY]
- **Scale Down:** [SCALE_DOWN_POLICY]
- **Min Instances:** [MIN]
- **Max Instances:** [MAX]

## Rollback Procedures

### Automatic Rollback Triggers
- [TRIGGER_1]
- [TRIGGER_2]

### Manual Rollback Steps
1. [STEP_1]
2. [STEP_2]
3. [STEP_3]

### Rollback Verification
- [VERIFICATION_1]
- [VERIFICATION_2]

## Monitoring During Deployment

### Metrics to Monitor
- [METRIC_1]
- [METRIC_2]
- [METRIC_3]

### Alert Configuration
- [ALERT_1]
- [ALERT_2]

## Security

### Secrets Management
- **Tool:** [TOOL]
- **Rotation:** [ROTATION_POLICY]

### Image Scanning
- **Tool:** [TOOL]
- **Frequency:** [FREQUENCY]

### Access Control
[ACCESS_CONTROL_POLICY]

## Maintenance Windows

| Environment | Day | Time (UTC) | Duration |
|-------------|-----|------------|----------|
| Development | [DAY] | [TIME] | [DURATION] |
| Staging | [DAY] | [TIME] | [DURATION] |
| Production | [DAY] | [TIME] | [DURATION] |

## Deployment Checklist

### Pre-Deployment
- [ ] [CHECK_1]
- [ ] [CHECK_2]
- [ ] [CHECK_3]

### During Deployment
- [ ] [CHECK_1]
- [ ] [CHECK_2]

### Post-Deployment
- [ ] [CHECK_1]
- [ ] [CHECK_2]
- [ ] [CHECK_3]

## Contact Information

| Role | Name | Contact |
|------|------|---------|
| [ROLE_1] | [NAME] | [CONTACT] |
| [ROLE_2] | [NAME] | [CONTACT] |
