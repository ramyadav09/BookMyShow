# GitHub Copilot — Agent Instructions

> Instructions for GitHub Copilot in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Copilot must never suggest or automatically trigger unapproved destructive actions. All changes require an approved plan and explicit user consent ("OK" or "Go").

## Required References
1. [`AGENTS.md`](../../AGENTS.md) — Project standards and tech stack
2. [`.agents/guardrails.md`](../guardrails.md) — Security locks
3. [`.agents/response-style.md`](../response-style.md) — Formatting rules

## Hard Prohibitions
- Do not suggest or run mutating `git` or `gh` commands.
- Do not suggest file deletions or database `DELETE`/`DROP` statements.
- Never suggest outbound network calls or tunneling scripts without a lease.
- Never inspect or output `.env` secrets.
- Keep all operations confined to the workspace root.
