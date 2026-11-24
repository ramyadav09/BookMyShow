# Gemini CLI — Agent Instructions

> Configuration for the Gemini CLI agent working in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Regardless of CLI auto-execution flags or autonomy levels, **NO action may proceed without explicit user consent.** Present a plan first and wait for explicit confirmation ("OK" / "Go").

## Mandatory Reads
1. [`AGENTS.md`](../../AGENTS.md) — Project identity and stack definition
2. [`.agents/guardrails.md`](../guardrails.md) — Zero-trust rules & hook locks
3. [`.agents/response-style.md`](../response-style.md) — Formatting and conventions

## Operational Constraints
- Read-only Git is allowed (`git status`, `git diff`, `git log`); all mutations and `gh` CLI commands are hard-blocked.
- Zero file or database record deletions.
- Workspace strictly isolated to current repository root.
- Outbound network operations are denied unless an active timed lease is present.
- Do not inspect or touch `.env` files.
