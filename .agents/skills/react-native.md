# React Native (Pure CLI / Non-Expo)

All engineering rules from `engineering.md` apply. This adds only what is specific to pure mobile app development on the modern React Native CLI engine.

## Core Architecture & Environment

- **New Architecture:** All code must run natively on the New Architecture (Fabric for rendering, TurboModules for native modules). Never write code that relies on legacy asynchronous bridges.
- **Native Languages:** When modifying native layer configurations, use Kotlin for Android and Swift (via Swift Package Manager) for iOS. Do not use legacy Java or Objective-C.
- **Edge-to-Edge Layouts:** Target native edge-to-edge constraints directly. Do not inject hardcoded height padding hacks for the status bar or navigation bars. Always use `SafeAreaView` from `react-native-safe-area-context`.

## TypeScript & Native Typing

- Maintain strict mode (`strict: true`). No `any` without a valid reason and a `// ponytail:` comment.
- Co-locate types: Props interfaces must live inside the same file as the component, not in a shared types directory.
- Use explicit native typing hooks appropriately (e.g., `StyleProp<ViewStyle>`, `GestureResponderEvent`).

## Component Constraints

- Functional components only with destructured props signatures. No class components.
- One component per file. The filename must match the component name exactly.
- **Text Safety:** Every single raw text string must be wrapped explicitly inside a native `<Text>` component. Unwrapped layout strings are strict errors and will crash the non-Expo runtime.
- **Platform Separation:** For complex deviations, use platform-specific files (`Component.ios.tsx` and `Component.android.tsx`) rather than inline `Platform.OS === 'ios'` logical branches.

## Modern API Enforcements

- **Interactions:** Use `<Pressable>` exclusively for touch interactions. Legacy handlers (`TouchableOpacity`, `TouchableHighlight`) are strictly forbidden.
- **Hit Slops:** Always provide friendly touch targets on small interactive buttons using an explicit hitSlop rule: `hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}`.
- **Lists:** For dynamic arrays, use `<FlatList>` or Shopify’s `<FlashList>`. Never map items into custom `<ScrollView>` loops. Always provide a stable string-based `keyExtractor`.
- **Visibility Checks:** For view checks or infinite lists, use the modern native core **Intersection Observer API** rather than calculating bounds via raw scroll position listeners.

## Loading Screens & Layout Profiles

- **Native Skeletons:** Use `boneyard-js/native` to eliminate layout pop-ins during data fetching. Never import from the web paths to avoid Metro bundler crashes.
- **Profile Generation:** Generate layout profiles using the local CLI stream helper (`npx boneyard-js build --native --out ./bones`) while navigating target screens on a physical device or native simulator.
- **Initialization:** Import the layout registry once at your primary application root node entry file (`App.tsx` or `index.js`): `import './bones/registry'`.

## Styling & Performance

- **Static Stylesheet Rule:** Declare `StyleSheet.create` configurations strictly outside the component lifecycle to avoid reference recalculation and thread garbage collection.
- **No Inline Objects:** Never write inline arrays or inline dynamic object literals inside styling parameters (`style={[styles.box, { padding: 10 }]}`). Map dynamic variables directly into semantic stylesheet variables or state modifiers.

## Security & Storage

- Do not store authentication signatures, access tokens, JWTs, or personal identifiers inside `AsyncStorage`.
- Always default to hardware-backed platform utilities utilizing `react-native-keychain` for secure, encrypted token management.

## Testing

- Test operational user flows rather than implementation internals using `@testing-library/react-native`.
- Mock out native mobile dependencies (like NativeModules, Keychain, or Push Notification frameworks) at your central testing setup runner configuration boundary.
