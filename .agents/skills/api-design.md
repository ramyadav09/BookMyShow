# API & Interface Design Skill

> **Universal principles for robust, scalable, and maintainable APIs.**

---

## 1. RESTful Standards & URI Design

- **Resource-Oriented URIs**: Use plural nouns (`/api/v1/orders`, `/api/v1/users`). Avoid verbs in URIs.
- **HTTP Method Semantics**:
  - `GET`: Safe, idempotent read operations.
  - `POST`: Create a new resource or execute an action.
  - `PUT`: Complete resource replacement (idempotent).
  - `PATCH`: Partial resource update.
  - `DELETE`: Remove a resource (idempotent).
- **Versioning**: Always prefix public endpoints with `/api/v1/` to ensure non-breaking evolution.

---

## 2. Standardized Error Responses (RFC 7807)

Always return structured errors following RFC 7807 Problem Details:

```json
{
  "type": "https://api.example.com/errors/invalid-input",
  "title": "Invalid Request Parameters",
  "status": 400,
  "detail": "Field 'email' must be a valid email address.",
  "instance": "/api/v1/users/register",
  "code": "VALIDATION_FAILED",
  "errors": [
    { "field": "email", "message": "Invalid format" }
  ]
}
```

---

## 3. Essential Enterprise Patterns

### A. Idempotency Keys
- For financial, booking, or non-idempotent mutations, accept an `Idempotency-Key` header.
- Store results for cached replay within a 24-hour window to prevent double charges/submissions.

### B. Pagination & Filtering
- Use cursor-based pagination for large datasets:
  `GET /api/v1/events?limit=20&cursor=eyJpZCI6MTAwfQ`
- Include total count or `hasMore` indicator in paginated metadata.

### C. Rate Limiting
- Return standard rate-limit headers:
  - `X-RateLimit-Limit`: Maximum requests permitted.
  - `X-RateLimit-Remaining`: Remaining request quota.
  - `X-RateLimit-Reset`: Unix timestamp when quota resets.
- Return HTTP `429 Too Many Requests` when limit is exceeded.

---

## 4. Schema-First Validation
- Validate all incoming request payloads and outgoing responses using schemas (Zod, Pydantic, JSON Schema).
- Fail fast at the boundary before calling domain services.
