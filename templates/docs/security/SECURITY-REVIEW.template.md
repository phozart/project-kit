# Security Review: [PROJECT_NAME]

**Date:** [DATE]
**Version:** [VERSION]
**Reviewer:** [REVIEWER]

## Executive Summary

[EXECUTIVE_SUMMARY]

## Threat Model

### Assets
- [ASSET_1]
- [ASSET_2]
- [ASSET_3]

### Threats
| Threat | Asset | Impact | Likelihood | Risk Level |
|--------|-------|--------|------------|------------|
| [THREAT_1] | [ASSET] | [HIGH|MEDIUM|LOW] | [HIGH|MEDIUM|LOW] | [CRITICAL|HIGH|MEDIUM|LOW] |
| [THREAT_2] | [ASSET] | [HIGH|MEDIUM|LOW] | [HIGH|MEDIUM|LOW] | [CRITICAL|HIGH|MEDIUM|LOW] |
| [THREAT_3] | [ASSET] | [HIGH|MEDIUM|LOW] | [HIGH|MEDIUM|LOW] | [CRITICAL|HIGH|MEDIUM|LOW] |

### Attack Vectors
- [VECTOR_1]
- [VECTOR_2]
- [VECTOR_3]

## Security Controls

### Authentication
- **Method:** [AUTH_METHOD]
- **Strength:** [STRENGTH_ASSESSMENT]
- **Multi-Factor:** [YES|NO]
- **Session Management:** [SESSION_APPROACH]

### Authorization
- **Model:** [RBAC|ABAC|ACL|OTHER]
- **Implementation:** [IMPLEMENTATION_DETAILS]
- **Privilege Escalation:** [PREVENTION_MEASURES]

### Data Protection

#### Data at Rest
- **Encryption:** [ENCRYPTION_METHOD]
- **Key Management:** [KEY_MANAGEMENT_APPROACH]

#### Data in Transit
- **Encryption:** [TLS_VERSION]
- **Certificate Management:** [CERT_APPROACH]

#### Sensitive Data
| Data Type | Classification | Protection Method |
|-----------|----------------|-------------------|
| [DATA_TYPE_1] | [CLASSIFICATION] | [PROTECTION] |
| [DATA_TYPE_2] | [CLASSIFICATION] | [PROTECTION] |

### Input Validation
- **Validation Method:** [METHOD]
- **Sanitization:** [APPROACH]
- **Injection Prevention:** [MEASURES]

### Output Encoding
- **Method:** [METHOD]
- **XSS Prevention:** [MEASURES]

### Error Handling
- **Logging:** [LOGGING_APPROACH]
- **Information Disclosure:** [PREVENTION_MEASURES]

## Vulnerability Assessment

### Critical Findings

#### VULN-001: [VULNERABILITY_TITLE]
- **Severity:** CRITICAL
- **Description:** [DESCRIPTION]
- **Impact:** [IMPACT]
- **Affected Component:** [COMPONENT]
- **Remediation:** [REMEDIATION]
- **Status:** [OPEN|IN_PROGRESS|FIXED|MITIGATED]

---

### High Findings

#### VULN-002: [VULNERABILITY_TITLE]
- **Severity:** HIGH
- **Description:** [DESCRIPTION]
- **Impact:** [IMPACT]
- **Affected Component:** [COMPONENT]
- **Remediation:** [REMEDIATION]
- **Status:** [OPEN|IN_PROGRESS|FIXED|MITIGATED]

---

### Medium Findings

#### VULN-003: [VULNERABILITY_TITLE]
- **Severity:** MEDIUM
- **Description:** [DESCRIPTION]
- **Impact:** [IMPACT]
- **Affected Component:** [COMPONENT]
- **Remediation:** [REMEDIATION]
- **Status:** [OPEN|IN_PROGRESS|FIXED|MITIGATED]

---

### Low Findings

#### VULN-004: [VULNERABILITY_TITLE]
- **Severity:** LOW
- **Description:** [DESCRIPTION]
- **Impact:** [IMPACT]
- **Affected Component:** [COMPONENT]
- **Remediation:** [REMEDIATION]
- **Status:** [OPEN|IN_PROGRESS|FIXED|MITIGATED]

## Compliance

### Standards
- [STANDARD_1]: [COMPLIANCE_STATUS]
- [STANDARD_2]: [COMPLIANCE_STATUS]
- [STANDARD_3]: [COMPLIANCE_STATUS]

### Regulations
- [REGULATION_1]: [COMPLIANCE_STATUS]
- [REGULATION_2]: [COMPLIANCE_STATUS]

## Security Testing

### Testing Types Performed
- [ ] Static Application Security Testing (SAST)
- [ ] Dynamic Application Security Testing (DAST)
- [ ] Penetration Testing
- [ ] Security Code Review
- [ ] Dependency Scanning
- [ ] Container Scanning

### Tools Used
- [TOOL_1]
- [TOOL_2]
- [TOOL_3]

## Recommendations

### Immediate Actions (Priority 1)
1. [RECOMMENDATION_1]
2. [RECOMMENDATION_2]

### Short-term Actions (Priority 2)
1. [RECOMMENDATION_3]
2. [RECOMMENDATION_4]

### Long-term Actions (Priority 3)
1. [RECOMMENDATION_5]
2. [RECOMMENDATION_6]

## Security Metrics

| Metric | Value | Target |
|--------|-------|--------|
| Vulnerabilities Resolved | [COUNT] | [TARGET] |
| Average Resolution Time | [TIME] | [TARGET] |
| Security Test Coverage | [PERCENTAGE]% | [TARGET]% |

## Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| [ROLE] | [NAME] | [SIGNATURE] | [DATE] |
