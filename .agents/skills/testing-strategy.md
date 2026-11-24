# Testing Strategy & Quality Assurance Skill

> **Universal testing patterns and quality standards for all development changes.**

---

## 1. The Testing Pyramid

Every system should maintain testing balance:

```text
       /  E2E Tests  \       (Fewest: Critical user journeys, high confidence)
      / Integration   \      (Moderate: API endpoints, database queries, contracts)
     /   Unit Tests    \     (Most: Pure functions, domain calculations, utilities)
```

---

## 2. Testing Principles

1. **Test Behavior, Not Implementation Details**: Test inputs, outputs, and side effects. Avoid asserting against internal private state.
2. **Deterministic & Isolated**: Tests must never depend on external network services. Mock external APIs at the boundary layer.
3. **Co-location**: Keep test files alongside the source files they test (`Feature.test.ts` next to `Feature.ts` or inside `__tests__/`).
4. **Fast Feedback**: Unit test suites must run in seconds. Separate slow E2E suites from the unit test runner.

---

## 3. Test Categories & Guidelines

### A. Unit Tests
- Scope: Independent modules, algorithms, data formatting, validators.
- Requirement: 100% coverage on core business formulas (pricing, permissions, state transitions).
- Practice: Red-Green-Refactor loop.

### B. Integration Tests
- Scope: Database repositories, API routes, middleware chains.
- Practice: Use in-memory or ephemeral test containers (e.g. SQLite, Docker test instances).
- Clean state: Reset test database state between runs (seed clean fixtures).

### C. End-to-End (E2E) Tests
- Scope: High-value user flows (e.g., User Sign Up -> Browse -> Checkout -> Confirmation).
- Stability: Use semantic locators (roles, text, accessible labels). Never use fragile DOM selectors.

---

## 4. Verification Checklist Before Marking Done

- [ ] All new logic has corresponding test coverage.
- [ ] Edge cases tested: `null`, `undefined`, empty collections, maximum boundaries.
- [ ] Error paths tested: invalid input, failed dependencies, timeout scenarios.
- [ ] Test suite runs completely clean without unhandled promise rejections.
