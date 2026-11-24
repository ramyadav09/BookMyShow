# React / TypeScript

All engineering rules from `engineering.md` apply. This adds only what's specific to this stack.

## TypeScript

- Use strict mode (`strict: true` in `tsconfig.json`). No `any` unless you have a documented reason and a `// ponytail:` comment.
- Prefer `interface` for object shapes. Use `type` for unions, intersections, and computed types.
- Use `unknown` over `any` when the type is genuinely not known. Narrow with type guards.
- Props interfaces should live in the same file as the component, not in a shared types file. Co-locate.

## Components

- Functional components only. No class components.
- One component per file. The filename matches the component name.
- If a component grows past ~150 lines, extract the sub-sections into their own components. But don't pre-split.
- Props destructuring in the function signature. Default values via defaults, not `defaultProps`.

## State

- Local state (`useState`) first. Ask: does this actually need to be global?
- Server state: fetch it, don't store it in global state for no reason. React Query / TanStack Query if the project uses it. If not, `useEffect` + local state is fine for simple fetches.
- Do not create a context/store/hook unless you have at least two consumers that genuinely need shared state.

## Data Fetching & Loading

- Fetch close to where the data is used. Not in a top-level provider for everything.
- Handle loading, error, and empty states explicitly. No silent failures.
- If you use a fetching library, use its cache / invalidation. Do not build a second cache layer.
- **Skeleton Screens:** Use `boneyard-js/react` to prevent layout shifts. Wrap dynamic views in `<Skeleton name="...">` and supply an accurate structural `fixture` if the component layout relies heavily on runtime API payloads.
- **Build-Time Snapshots:** Always run `npx boneyard-js build` during deployment or local UI layout overhauls to ensure `.bones.json` profiles map seamlessly across active responsive breakpoints.
- Ensure `import './bones/registry'` is strictly isolated at the application root entry point (`main.tsx` / `layout.tsx`).

## Forms

- For simple forms: controlled inputs with `useState`. No library needed.
- For complex forms (multi-step, dynamic fields, cross-field validation): use React Hook Form or similar if already installed. Otherwise, `useState` with validation logic is fine.
- Always validate before submission. Show errors next to the relevant field.

## Routing

- Use whatever routing library the project uses (React Router, TanStack Router, etc.).
- Route definitions in one place. Not scattered across components.
- Lazy-load route-level components with `React.lazy` when it makes a measurable difference.

## Accessibility

- Use semantic HTML: `<button>`, `<nav>`, `<main>`, `<input>`, `<label>`.
- Labels must be associated with inputs (either `htmlFor` or wrapping).
- Interactive elements must be keyboard-navigable. Focus styles must be visible.
- Meaningful `alt` text on images. Decorative images get `alt=""`.

## Styling

- Use whatever the project uses (CSS modules, Tailwind, styled-components, plain CSS). Do not introduce a new styling approach.
- No inline styles for anything non-trivial.
- Keep styles scoped to the component.

## Performance

- Do not optimize prematurely. React is fast enough for most UIs.
- Only add `useMemo`, `useCallback`, or `React.memo` when there is a measured problem, not a theoretical one.
- Do not create new objects/functions in render unless necessary (this is what `useCallback` / `useMemo` are for, but only when needed).

## Testing

- Test behavior, not implementation. What the user sees/can do, not internal state.
- Use `@testing-library/react` if it's in the project. `render`, `screen`, `userEvent`.
- Mock network requests at the API boundary. Do not mock React internals.
