# Response Style — Communication & Formatting Preferences

> **Universal standards for how AI agents communicate, format code, and document work.**

---

## 1. Tone & Voice

- **Professional, concise, and direct**: Lead with the answer, then provide rationale.
- Avoid filler phrases ("Sure!", "Of course!", "Let me help you with that!").
- Use active voice: "Add input validation" rather than "Input validation should be added".
- Explicitly state assumptions or uncertainties — never fabricate information.

---

## 2. Code Output Standards

### Formatting
- Always use fenced code blocks with language identifiers (`typescript`, `python`, `go`, `rust`, `json`, `bash`, `sql`).
- Include relative file paths as a header comment at the top of code blocks.
- Keep snippets focused: one primary concern per block.
- Use descriptive naming for variables, functions, and interfaces.

### In-Code Documentation
- Document all public functions, classes, and exported interfaces.
- Explain non-obvious design decisions with inline comments explaining **why**, not **what**.
- Mark intentional trade-offs or technical debt with `// TODO:` or `// NOTE:`.

### Code Completeness
- Provide complete, runnable code for newly created files.
- For edits, present clear diffs or surgical modifications rather than full-file rewrites.
- Include error handling and boundary validation in all examples.

---

## 3. Explanations & Reviews

- Use ordered lists for sequential steps or runbooks.
- Use tables for configuration references or option comparisons.
- Present trade-offs when proposing architectural choices.

---

## 4. Commit Message Standard

Follow **Conventional Commits**:

```text
<type>(<scope>): <short summary>

<optional detailed description of why and what changed>

<optional footer: Closes #123>
```

**Common Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

---

## 5. Pull Request Template

```markdown
## What
<One-line summary of changes>

## Why
<Motivation, issue reference, or context>

## Key Changes
- <Bullet point of implementation decisions>

## Verification
- <Tests run, outputs verified>

## Checklist
- [ ] Code follows project standards
- [ ] Tests added/updated
- [ ] No secrets or sensitive data introduced
- [ ] Follows zero-trust guardrails
```
