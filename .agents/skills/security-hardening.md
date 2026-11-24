# Security Hardening & OWASP Defense Skill

> **Core security principles, vulnerability prevention, and defensive engineering.**

---

## 1. Top Defensive Principles

1. **Zero-Trust Input**: Treat every incoming request, header, query parameter, and payload as hostile.
2. **Principle of Least Privilege**: Services and database connections should have only the minimum necessary permissions.
3. **Fail Securely**: Default to denying access when checks fail. Never fail open.
4. **Defense in Depth**: Implement validation at the gateway, controller, service, and database layers.

---

## 2. OWASP Top 10 Mitigations

### A. Injection Prevention (SQL / NoSQL / Command)
- Always use parameterized queries or ORM abstractions.
- Never concatenate raw user input into database queries or shell command strings.

### B. Broken Authentication & Session Management
- Store passwords using strong hashing algorithms (Argon2id, bcrypt with cost ≥ 12).
- Set cookies with `HttpOnly`, `Secure`, and `SameSite=Lax` or `Strict` attributes.
- Invalidate sessions on password change or explicit logout.

### C. Broken Object Level Authorization (BOLA / IDOR)
- Never rely on user-supplied IDs alone (e.g. `/api/orders/123`).
- Always verify that the authenticated user owns or has explicit permission to access the requested resource:
  `SELECT * FROM orders WHERE id = :id AND user_id = :authenticatedUserId`

### D. Cross-Site Scripting (XSS) & CSRF
- Context-encode all user-supplied data rendered in HTML or templates.
- Configure Content Security Policy (CSP) headers.
- Require anti-CSRF tokens for cookie-based state-changing requests.

---

## 3. Security Checklist for Every Feature

- [ ] Inputs validated and sanitized against strict schemas.
- [ ] Authorization checks verified at the handler level.
- [ ] No sensitive data logged (passwords, tokens, payment details).
- [ ] Rate limiting applied on public and authentication endpoints.
- [ ] Secure HTTP headers configured (HSTS, CSP, X-Content-Type-Options).
