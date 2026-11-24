---
trigger: always_on
---

# Google Antigravity — Agent Rules

> Adapter for Google Antigravity (AGY). Loads automatically on every interaction.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Regardless of the active agent mode or auto-run configuration, **NO action, file generation, or execution may proceed without explicit user consent.** Always present a plan and wait for "OK" or "Go".

**Mandatory Reads:**
1. [`AGENTS.md`](../../AGENTS.md) — Project standards, architecture, and tech stack definitions
2. [`.agents/guardrails.md`](../guardrails.md) — Zero-trust rules & hook locks
3. [`.agents/response-style.md`](../response-style.md) — Communication conventions

## Critical Inviolable Constraints
- **Zero Git Mutations**: Never execute `git add`, `commit`, `push`, `pull`, `reset`, or `gh` commands. User handles all git mutations manually. (Read-only `status`, `diff`, `log` are allowed).
- **Zero Deletes**: Never delete any file or execute database `DELETE`/`DROP`/`TRUNCATE`.
- **Network Isolation**: Outbound requests (`curl`, `wget`, `ssh`) are forbidden without prior timed lease approval.
- **Secrets Protection**: Never read or modify `.env` or credential files directly.
- **Project Boundary**: Remain strictly inside the workspace root.
- **Zero-Trust Shell**: Every shell tool call triggers a `force_ask` approval gate.
