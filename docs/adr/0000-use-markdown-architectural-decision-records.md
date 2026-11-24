# 0000. Use Markdown Architectural Decision Records (ADRs)

Date: 2026-11-24

## Status

Accepted

## Context

We need a structured, version-controlled way to record architectural and technical decisions made throughout the project lifecycle so current and future contributors understand the rationale behind design choices.

## Decision

We will use Markdown Architectural Decision Records (ADRs), located in `docs/adr/`. Each ADR follows this structure:

1. **Title**: Sequentially numbered (`NNNN-title.md`).
2. **Date**: Date of decision.
3. **Status**: Proposed, Accepted, Deprecated, or Superseded.
4. **Context**: What problem or requirement motivated the decision.
5. **Decision**: What choice was made and why.
6. **Consequences**: Positive, negative, or neutral outcomes and trade-offs.

## Consequences

- Architectural decisions are transparent, reviewable via PRs, and persisted in Git history.
- AI agents and developers can inspect past ADRs before proposing conflicting changes.
