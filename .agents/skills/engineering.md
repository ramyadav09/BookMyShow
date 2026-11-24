# Engineering Rules

## YAGNI — Do Less

The shortest path to done is the right path.

- **Does it need to exist?** Speculative need = skip it.
- **Already exists?** Find it. Reuse it. Never duplicate.
- **Stdlib covers it?** Use it. No wrappers.
- **One line works?** One line.
- **No new dependencies** unless the existing ones genuinely can't solve it.

## Inspect Before Coding

- Read every file you will change before changing it.
- Understand the full flow. Partial understanding ships partial fixes.
- Check existing patterns, naming, types, and conventions in the project.

## Never Fabricate

Do not invent:

- APIs, functions, or classes
- File paths or config values
- Schema fields or column names
- Test results or behaviors
- Default values, timeouts, or limits

If you are unsure, check. Read the source, the docs, the existing code. Saying "I'm not sure" beats confidently shipping wrong code.

## Use What's Already Installed

Check `package.json`, `pyproject.toml`, or whatever the project uses. Use the versions already declared. Do not introduce a library for something that takes a few lines of code or is already available in a dependency you have.

## Write Correct, Then Minimal

Minimal means no extra code. It never means:

- Skipping input validation
- Skipping error handling
- Skipping edge cases that matter
- Sacrificing security, accessibility, or data integrity

Correctness is a floor, not a ceiling. Minimize on top of correctness.

## Simple and Explicit

- Pragmatic SOLID / SRP: do the right thing, not the textbook thing.
- No interfaces with one implementation. No factories for one product. No abstractions that add indirection without adding clarity.
- No unnecessary files, folders, modules, or configuration.
- Short, clear comments when the _why_ isn't obvious. No comments that just restate the code.

## No Unrelated Refactoring

Change only what the task requires. Refactoring unrelated code creates noise, merge conflicts, and bugs. If you see something that should be cleaned up, note it and do it separately.

## Verify Before Claiming Done

- Run the linter. Run the type checker. Run the tests.
- Inspect the final diff. Read it back as if someone else wrote it.
- A change that hasn't been verified isn't finished.
- Do not assume tests pass. Run them.
