# Design

All engineering rules from `engineering.md` apply. When touching frontend UI, read `react.md` too. This adds only design-specific rules.

## No AI-Generated Slop

Do not use AI-generated UI patterns, stock landing page layouts, or template designs. Design from the actual data requirements and the project's existing visual language. If a component already exists in the codebase, match its style exactly. Do not invent a new visual pattern for every feature.

## Strict Color Palette (Max 5 Tokens)

The application must enforce a strict, restricted semantic color palette consisting of **2 to 5 color tokens maximum** per active theme state.

- **1. Base Background:** The solid surface background color.
- **2. Content Primary:** The primary high-contrast token for main typography and layout boundaries.
- **3. Content Muted:** A lower-contrast variant for borders, descriptive captions, and secondary actions.
- **4. Accent (Optional):** Exactly **one** intentional accent token used exclusively for the primary call-to-action or critical focus state. Do not bleed this color across body text or decorative layouts.
- **5. Feedback (Optional):** Standardized, desaturated semantic tokens strictly for errors, warnings, or success alerts.
- _Rule:_ The AI must read the active CSS entry file to fetch these tokens. Introducing arbitrary shades, secondary hues, or custom hex codes inside components violates this specification.

## Layout & Structural Non-Genericity

Ban generic AI-template layouts (e.g., standard centered hero sections, floating glassmorphism cards, or generic three-column feature blocks).

- **Strict Mobile-First Execution:** All layouts must be conceptualized and written for mobile viewports first. Un-prefixed utility classes must represent the mobile layout. Responsive prefixes (`md:`, `lg:`) are strictly for progressive enhancement on larger viewports.
- **Asymmetric & Data-Driven:** Build layouts that adapt directly to the shapes of the data. Use structured asymmetrical grids or multi-pane side-by-side dashboards instead of stacked rows.
- **Structural Borders over Shadows:** Separate sections using clean, 1px solid borders. Do not use blurry drop shadows to create depth or mask weak layout composition.
- **Unified Grids:** Layouts must lock rigidly into an underlying grid. Use CSS Grid or Flexbox for structure. Absolute positioning for layout structure is a failure.
- **Single Component Tree Response:** Leverage responsive utility chains natively rather than branching into separate mobile and desktop component trees. Fixed or fluid width; do not mix approaches in a single layout.

## Tailwind CSS (v4+ Engine)

The project strictly uses **Tailwind v4+**. There is **no tailwind.config.js** file. All theme configurations, custom variables, and plugins live directly inside the global CSS entry file.

- **Mobile-First Class Ordering:** Order class strings strictly from the smallest breakpoint to the largest. Mobile utilities come first, followed by `sm:`, `md:`, `lg:`, and `xl:` additions (e.g., `className="grid grid-cols-1 gap-2 md:grid-cols-3 md:gap-4 lg:grid-cols-4"`). Mixing mobile-first order or designing desktop-first with desktop overrides is a strict compilation error.
- Use Tailwind's native utility design tokens (`text-*`, `bg-*`, `gap-*`, `p-*`) over raw arbitrary values (`12px`, `#333`).
- Compose classes, do not override. Write `className="p-4 text-sm"`, never `className="p-4" style={{ fontSize: 14 }}`.
- Extract repeated patterns into `@apply` in the global CSS file only when the exact same 5+ class string appears across 3+ distinct component files. Otherwise, inline classes are mandatory.

## Theme System (v4 CSS Configuration)

- **CSS Source of Truth:** All customizations for colors, spacing, and typography must reside inside the main CSS entry file using the Tailwind v4 `@theme` directive blocks (e.g., `@theme { --color-primary: #...; }`).
- **Theme Variables:** Store theme tokens exclusively in this central CSS block. Never scatter style values across component files. A utility token used in multiple places comes from one CSS variable rule.
- **Dark Mode:** Use Tailwind v4 native variants driven by class-based toggling (`dark` class applied to the `<html>` root node) for user preferences.
- **No Inline Values:** No inline hex colors, RGB values, or raw HSL values are allowed inside components. Every layout element must map directly back to a named theme token defined in the `@theme` block.

## Design Principles

- **No maximalism.** Dense, compact, utility-first layouts over spacious, vacuous "marketing" layouts. Use space intentionally to separate data groups, not to decorate.
- **Compact by default.** Information density is a core feature. Generous whitespace is reserved for breathing room between major functional groups, not for filling blank screen real estate.
- **Professional over flashy.** Neutral palette, consistent type scale, aligned grid. Gradients on buttons, glowing ambient glows, and glassmorphism elements are strictly banned.
- **Hierarchy through weight:** Establish visual hierarchy using font weight and size, not color fireworks. Bold for primary headings, medium for secondary elements, and regular for body text.
- **No decorative elements.** Every visual asset must have a functional purpose. If it does not actively help the user understand data or perform an action, remove it completely.

## Animations

- Avoid heavy animations. No parallax scrolling, no scroll-triggered fade-ins, no animated utility counters, and no full-page transitions.
- Micro-interactions are fine: `transition duration-150` on hover/focus states, and a subtle `scale-95` on button presses for tactile feedback.
- Every animation must be short (< 300ms) and purposeful (action feedback, not visual decoration).
- Respect accessibility settings. Wrap custom movement transitions inside `motion-safe:`.

## File and Component Length

- A component file should not exceed 500 lines. If it does, extract sub-sections into localized sub-components.
- Keep file count minimal: only split when a file genuinely has two distinct architectural responsibilities. Do not create a new file for a short helper block—keep it inline.
- One concern per file is the target. One concern per folder is over-normalization unless explicitly demanded by project conventions.
