# AWS Kiro — Agent Steering

> Technology, product, and structure steering for AWS Kiro in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Regardless of execution mode, **NO change or action may proceed without explicit user consent.** Present a plan first and wait for explicit confirmation ("OK" / "Go").

## Mandatory Reads
1. [`AGENTS.md`](../../AGENTS.md) — Stack definition & guidelines
2. [`.agents/guardrails.md`](../guardrails.md) — Zero-trust rules
3. [`.agents/response-style.md`](../response-style.md) — Conventions

## Operational Boundaries
- Hard Git & GitHub mutation lockdown (read-only git allowed).
- Database & file deletion lock (no deletes).
- Strict network isolation (timed lease mechanism via `unlock-network.ps1`).
- Secrets protection (no inspecting/modifying .env).
- Strict workspace boundary confinement.
