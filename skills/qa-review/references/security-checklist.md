# Security Checklist

Comprehensive security validation based on OWASP Top 10 and security best practices.

## OWASP Top 10 (2023)

### 1. Broken Access Control
- [ ] Authorization checked on all protected endpoints
- [ ] Users cannot access resources they don't own
- [ ] Admin functions require admin role
- [ ] API endpoints enforce rate limiting
- [ ] No insecure direct object references (IDOR)
- [ ] Directory listing disabled
- [ ] CORS configured restrictively

### 2. Cryptographic Failures
- [ ] Passwords hashed with bcrypt/Argon2 (not MD5/SHA1)
- [ ] HTTPS enforced (no HTTP)
- [ ] TLS 1.2+ only
- [ ] Sensitive data encrypted at rest
- [ ] Strong encryption algorithms (AES-256)
- [ ] No hardcoded encryption keys
- [ ] Secure random number generation

### 3. Injection
- [ ] SQL queries use parameterized statements
- [ ] ORM used correctly (no raw SQL with user input)
- [ ] Command injection prevented (no shell execution with user input)
- [ ] LDAP injection prevented
- [ ] XPath injection prevented
- [ ] Template injection prevented
- [ ] Input validation on all user input

### 4. Insecure Design
- [ ] Threat modeling performed
- [ ] Security requirements defined
- [ ] Secure design patterns used
- [ ] Rate limiting on sensitive operations
- [ ] Multi-factor authentication for critical operations
- [ ] Separation of production and test environments

### 5. Security Misconfiguration
- [ ] Default credentials changed
- [ ] Unnecessary features disabled
- [ ] Error messages don't leak sensitive info
- [ ] Security headers configured (CSP, HSTS, X-Frame-Options)
- [ ] File permissions properly set
- [ ] Cloud storage buckets not publicly accessible
- [ ] Debug mode disabled in production

### 6. Vulnerable and Outdated Components
- [ ] Dependencies scanned for vulnerabilities
- [ ] No dependencies with known CVEs
- [ ] Dependencies regularly updated
- [ ] Unused dependencies removed
- [ ] Component versions pinned
- [ ] Dependency sources verified

### 7. Identification and Authentication Failures
- [ ] Strong password policy enforced (length, complexity)
- [ ] Account lockout after failed attempts
- [ ] MFA available for sensitive accounts
- [ ] Session IDs secure and regenerated after login
- [ ] Session timeout configured
- [ ] Logout invalidates session
- [ ] No credentials in URLs
- [ ] Password reset flow secure (token expiration, rate limiting)

### 8. Software and Data Integrity Failures
- [ ] Code signing implemented
- [ ] Dependencies verified (checksums, signatures)
- [ ] CI/CD pipeline secured
- [ ] No unsigned or unverified updates
- [ ] Integrity checks on critical data
- [ ] Audit trail for data changes

### 9. Security Logging and Monitoring Failures
- [ ] Authentication events logged
- [ ] Authorization failures logged
- [ ] Input validation failures logged
- [ ] Server errors logged
- [ ] Logs include sufficient context
- [ ] Logs protected from tampering
- [ ] Alerting configured for suspicious activity
- [ ] No sensitive data in logs

### 10. Server-Side Request Forgery (SSRF)
- [ ] URL validation on all external requests
- [ ] Whitelist of allowed domains
- [ ] Internal IP ranges blocked
- [ ] Redirect validation
- [ ] DNS rebinding protection

## Input Validation

- [ ] Whitelist validation (allow known good)
- [ ] Length limits enforced
- [ ] Type validation (numbers, emails, etc.)
- [ ] File upload validation (type, size, content)
- [ ] HTML input sanitized
- [ ] JSON schema validation

## Authentication

- [ ] Secure password storage (bcrypt, Argon2)
- [ ] Password strength requirements
- [ ] Rate limiting on login attempts
- [ ] Account lockout after failures
- [ ] MFA support
- [ ] Secure session management
- [ ] CSRF tokens on forms

## Authorization

- [ ] Role-based access control (RBAC)
- [ ] Principle of least privilege
- [ ] Authorization checked on every request
- [ ] No client-side authorization checks only
- [ ] API authorization enforced

## Data Protection

- [ ] PII identified and protected
- [ ] Sensitive data encrypted at rest
- [ ] Sensitive data encrypted in transit
- [ ] Data retention policies enforced
- [ ] Secure data deletion
- [ ] No sensitive data in logs
- [ ] No sensitive data in URLs

## API Security

- [ ] API authentication (JWT, OAuth, API keys)
- [ ] API rate limiting
- [ ] Input validation on all endpoints
- [ ] Output encoding
- [ ] CORS configured
- [ ] API versioning
- [ ] Deprecated endpoints removed

## Secrets Management

- [ ] No secrets in code
- [ ] No secrets in version control
- [ ] Environment variables or secrets manager used
- [ ] Secrets rotated regularly
- [ ] Access to secrets limited
- [ ] Secrets encrypted at rest

## XSS Prevention

- [ ] Output encoding/escaping
- [ ] Content Security Policy (CSP) header
- [ ] HttpOnly and Secure flags on cookies
- [ ] DOM-based XSS prevention
- [ ] Rich text sanitization

## CSRF Prevention

- [ ] CSRF tokens on state-changing operations
- [ ] SameSite cookie attribute
- [ ] Referer header validation
- [ ] Custom request headers

## SQL Injection Prevention

- [ ] Parameterized queries
- [ ] ORM used correctly
- [ ] Input validation
- [ ] Least privilege database accounts
- [ ] No dynamic SQL with user input
