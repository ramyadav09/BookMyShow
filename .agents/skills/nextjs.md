# Next.js (App Router)

All engineering rules from `engineering.md` and `react.md` apply. This file adds boundaries specifically optimized for Next.js production web architecture.

## Server Components by Default (Anti-Hydration Bloat)

- **Default to Server Components:** Every layout, page, and sub-component must remain a React Server Component (RSC) by default. Do not introduce `"use client"` unless the component directly relies on browser APIs (e.g., `window`, `localStorage`), state (`useState`), or direct user interaction handlers (`onClick`).
- **Leaf-Node Isolate:** Keep `"use client"` boundaries as small as possible at the lowest leaf nodes. Never slap `"use client"` at the top of a page layout or page directory. Wrap interactive inputs or buttons inside dedicated child files, and import them into clean, server-side frames.
- **Dependency Isolation:** Heavy processing scripts, Markdown parsers, and node-only cryptos must be evaluated inside server components. Shipping these packages down the hydration channel to the browser is a strict performance failure.

## High-Performance Data Fetching

- **Direct Database/Service Invocations:** Inside Server Components, fetch your data directly from your backend services, databases, ORMs, or native SDKs. Do not hit localized `/api/` fetch routes internally from an RSC; cut out the network hop completely.
- **Parallel and Deferred Execution:** Avoid async waterfall chains (`await getA(); await getB();`). Execute fetches in parallel using `Promise.all()` or separate slow components into localized async islands wrapped inside `<Suspense>` layers.
- **Server Actions for Mutations:** All data mutation logic (e.g., forms, button clicks, deletions) must leverage Server Actions (`"use server"`). Write Server Actions in explicit files co-located with their parent domains inside a clean action layer rather than mixing them haphazardly within client templates.

## Native SEO Optimization & Crawlability

- **Metadata API Enforcement:** Never write hardcoded HTML `<meta>` or `<title>` tags inside page headers. Export a clean static `metadata` object or a dynamic `generateMetadata()` function from pages and layouts.
- **Visible Initial HTML:** All main text information, layout structures, and descriptive metadata must be readable directly on the initial server response chunk. Banish empty loaders that wait for client-side fetches (`useEffect`) on indexing routes—search engines prioritize raw static strings.
- **Structured Data:** Inject automated JSON-LD schemas natively onto critical ranking destinations (products, blog posts, documentation grids) to guarantee perfect semantic understanding for both web search indexing engines and modern LLM crawlers.
- **Route Utilities:** Maintain automated generation arrays for `sitemap.ts` and ensure `robots.txt` files are correctly routing search spiders to verified directory sets.

## UX Streaming & Layout Stability

- **Granular Loading States:** Use `loading.tsx` at router directory breaks to automatically establish streaming bounds via React Suspense.
- **CLS Prevention with Skeletons:** Integrate `boneyard-js/react` over server components that switch states quickly. Wrap fluid items inside `<Skeleton name="...">` wrappers and inject exact height-mapped structural elements to ensure Core Web Vitals register near-zero Cumulative Layout Shift (CLS).
- **Native Image Execution:** Always wrap static asset dependencies inside the native `<Image>` component from `next/image`. Explicitly define `width` and `height` properties or use `fill` with appropriate relative parent frames to avoid text shifts while raw image buffers load.

## Things to Avoid (Over-Engineering / Slop)

- **No Client State for Server Data:** Do not fetch data on the server only to mirror it inside global state providers (e.g., Zustand, Context) unless multiple distinct interactive client items require write access to that state. Let Next.js handle the server-side lifecycle caching naturally.
- **No Manual Hydration Fixes:** Do not hide lazy styling bugs behind `useEffect(() => { setMounted(true) }, [])` hacks. Fix the root problem by ensuring the markup generated on the server exactly mirrors the values evaluated on the client's initial load.
- **Dynamic Switch Isolation:** Server variables like `cookies()`, `headers()`, or routing search parameters (`searchParams`) opt pages out of static optimization. Wrap these variables inside scoped, deferred chunks rather than blocking the compilation of full layouts.
