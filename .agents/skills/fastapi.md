# FastAPI / Python

All engineering rules from `engineering.md` apply. This adds only what's specific to this stack.

## Typing and Validation

- Use Pydantic v2 models for request/response bodies. Annotate types explicitly.
- Use `Query(...)`, `Path(...)`, `Body(...)` for parameter validation. Do not validate manually in the endpoint body.
- Return typed responses. Use `response_model` on the endpoint.
- For complex unions or optional fields, prefer `Annotated` with `Field(...)` over bare type hints.

## API Design

- Keep endpoints thin: validate, call a service/function, return. Business logic does not live in route handlers.
- Group related routes with `APIRouter`. One router per domain, not one per table.
- Use consistent error responses. A shared exception handler or a small base model is enough.
- HTTP status codes mean things. Use `201` for creation, `404` for not-found, `422` for validation errors (FastAPI does this automatically), `409` for conflicts.

## Dependency Injection

- Use FastAPI's `Depends()` for shared concerns: DB sessions, auth, config.
- Keep dependencies small and composable. One thing per dependency.
- For simple cases, a function is fine. No need for a class unless you need lifecycle management.

## Async vs Sync

- Use `async def` when the handler does I/O (DB calls, HTTP requests, file reads). Use `def` when it doesn't.
- Do not mix `await` and blocking I/O in the same handler.
- If a dependency is sync-only (e.g., some libraries), keep the handler `def`.

## Error Handling

- Let FastAPI handle validation errors. Do not catch `ValidationError` to return your own 422.
- For domain errors, raise HTTP exceptions (`HTTPException`) or custom exceptions with a global handler.
- Log at the point of failure, not just at the endpoint.

## Auth

- Use FastAPI's `Security()` with OAuth2 or API key schemes. Do not roll your own token parsing.
- Keep auth as a dependency, not middleware, unless you need it on every route.

## Database Interaction

- Use `Annotated[..., Depends(get_db)]` for session injection. Never create sessions in route handlers.
- Commit explicitly or use a transactional dependency. Do not rely on implicit commit behavior.
- For simple queries, raw SQL or lightweight query builders are fine. ORM is not mandatory.

## Testing

- Use `TestClient` for endpoint tests. It handles the ASGI app lifecycle.
- Mock external services at the boundary, not deep inside business logic.
- Test validation: send bad input and confirm you get 422, not 500.

## Configuration

- Use environment variables for secrets and environment-specific values. No hardcoded URLs, keys, or paths.
- A single config module or Pydantic `Settings` class is enough. No config framework for a few env vars.

## Imports and Structure

- Prefer absolute imports. Relative imports are fine within a package but don't nest deeper than necessary.
- One concern per module. Do not put routes, schemas, services, and models in one file.
- Keep `main.py` for app creation and startup only. Routes register via routers.
