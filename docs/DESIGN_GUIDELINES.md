# Design Guidelines for VibeFlip

This document covers Human Interface Guidelines (HIG) compliance and SwiftUI best practices for App Store approval.

> Reference: [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## 1. Human Interface Guidelines Compliance

### Core Principles

| Principle | VibeFlip Implementation |
|-----------|------------------------|
| **Clarity** | Clean UI, readable text, clear button purpose |
| **Deference** | Content (cards) is the focus, UI is minimal |
| **Depth** | Card animations provide visual hierarchy |

### Platform Integration

VibeFlip should feel native to iOS:

- [ ] Uses system fonts (San Francisco via SwiftUI defaults)
- [ ] Respects Safe Areas on all devices
- [ ] Supports Dynamic Type for accessibility
- [ ] Uses SF Symbols for icons
- [ ] Follows iOS navigation patterns

---

## 2. SwiftUI Best Practices

### Current Implementation Review

#### App Entry Point ✓
```swift
// VibeFlipApp.swift - Correct pattern
@main
struct VibeFlipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### Theme Support ✓
```swift
// ContentView.swift - Correct implementation
.preferredColorScheme(currentTheme.colorScheme)
```

#### Settings Pattern ✓
```swift
// Uses @AppStorage for persistence
@AppStorage("selectedLanguage") private var selectedLanguage = "English"
@AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
```

### Recommended Improvements

#### 1. Navigation Title Display Mode

Ensure consistent navigation bar style:

```swift
// SettingsView.swift - Currently correct
.navigationBarTitle(LocalizedStrings.getText("settings_title", language: selectedLanguage), displayMode: .inline)
```

#### 2. Button Accessibility

Ensure all buttons have accessibility labels:

```swift
Button(action: { showSettings = true }) {
    Image(systemName: "gearshape")
        // ... existing modifiers
}
.accessibilityLabel("Settings")
```

#### 3. Card Accessibility

Add VoiceOver support to card content:

```swift
CardView(card: card)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(card.text). \(card.action ?? "")")
```

---

## 3. Localization Requirements

### Current Language Support

VibeFlip supports 3 languages:
- English
- Русский (Russian)
- Español (Spanish)

### Localization Checklist

- [ ] All UI strings are localized
- [ ] Card content exists in all languages (70 cards × 3 languages = 210 total)
- [ ] Right-to-left (RTL) layout not required (none of the languages are RTL)
- [ ] Date formatting respects locale

### App Store Localization

In App Store Connect, localize:
- App Name (can vary by region)
- Subtitle
- Description
- Keywords
- Screenshots (recommended)

### Localization Best Practice

Consider moving from custom `LocalizedStrings` to native Swift localization:

```swift
// Future improvement: Use String(localized:)
Text(String(localized: "give_me_vibe"))
```

This integrates with Xcode's localization workflow and export tools.

---

## 4. Accessibility Compliance

### Required for App Store

| Feature | Status | Implementation |
|---------|--------|----------------|
| VoiceOver | [ ] Verify | Add `.accessibilityLabel()` |
| Dynamic Type | [ ] Verify | Use `.font()` with text styles |
| Reduce Motion | [ ] Verify | Respect `accessibilityReduceMotion` |
| Color Contrast | [ ] Verify | WCAG 2.1 AA minimum |

### VoiceOver Support

Audit these elements:

```swift
// Settings gear button
Button(action: { showSettings = true }) {
    Image(systemName: "gearshape")
}
.accessibilityLabel(LocalizedStrings.getText("settings_title", language: selectedLanguage))

// Give me vibe button - already has text, but verify
Button(action: { openCard() }) {
    HStack {
        Image(systemName: "sparkles")
        Text(LocalizedStrings.getText("give_me_vibe", language: selectedLanguage))
    }
}
.accessibilityHint("Reveals today's motivational card")
```

### Dynamic Type

Ensure text scales properly:

```swift
// Use semantic font styles
.font(.title3)  // ✓ Scales with Dynamic Type
.font(.system(size: 20))  // ⚠️ Fixed size - consider using font styles
```

### Reduce Motion

Respect user preferences for animations:

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// In openCard()
if reduceMotion {
    isCardOpen = true  // No animation
} else {
    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
        isCardOpen = true
    }
}
```

---

## 5. Layout Guidelines

### Safe Areas

Ensure content respects device safe areas:

```swift
// Already handled via SwiftUI defaults
VStack {
    // Content
}
.padding(.horizontal)
.padding(.top, 20)  // Additional padding from safe area
```

### Device Support

| Device | Consideration |
|--------|---------------|
| iPhone SE | Small screen - ensure text fits |
| iPhone 15 Pro Max | Large screen - content shouldn't look sparse |
| Dynamic Island | Respect safe area at top |

### Orientation

VibeFlip appears to be portrait-only. Verify in project settings:

1. Xcode > Target > General > Deployment Info
2. Device Orientation: ✓ Portrait only (recommended for card UI)

---

## 6. Visual Design Checklist

### Colors

- [ ] App works in Light mode
- [ ] App works in Dark mode
- [ ] Uses semantic colors (`Color(UIColor.systemBackground)`)
- [ ] Accent color is defined in `Assets.xcassets`
- [ ] Sufficient contrast for text readability

### Typography

- [ ] Uses system fonts (San Francisco)
- [ ] Text hierarchy is clear (title, body, caption)
- [ ] Line spacing is comfortable for reading

### Icons

- [ ] Uses SF Symbols (gearshape, sparkles)
- [ ] Icons have appropriate weight and size
- [ ] Icons render correctly in both color schemes

### App Icon

Requirements in `Assets.xcassets/AppIcon.appiconset`:

| Size | Purpose |
|------|---------|
| 1024×1024 | App Store |
| 180×180 | iPhone (60pt @3x) |
| 120×120 | iPhone (60pt @2x) |
| 167×167 | iPad Pro |
| 152×152 | iPad |

- [ ] Icon is provided for all required sizes
- [ ] No transparency (iOS icons must be opaque)
- [ ] No rounded corners (iOS applies them automatically)

---

## 7. Animation Guidelines

### Current Animations

```swift
// Card reveal animation
withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
    isCardOpen = true
}

// Card transition
.transition(.scale.combined(with: .opacity))
```

### Best Practices

- [ ] Animations are smooth (60fps)
- [ ] Animation duration is appropriate (0.3-0.6 seconds)
- [ ] Animations respect Reduce Motion setting
- [ ] No jarring or disorienting motion

---

## 8. Form and Settings Design

### Current Settings Implementation

The SettingsView uses SwiftUI `Form` which automatically:
- Groups content into sections
- Provides platform-appropriate styling
- Handles scrolling
- Supports Dynamic Type

### Improvements to Consider

```swift
// Add section footers for clarity
Section(header: Text("Theme"), footer: Text("Choose how the app appears")) {
    // Theme options
}

// Use built-in Picker style if appropriate
Picker("Language", selection: $selectedLanguage) {
    ForEach(languages, id: \.self) { language in
        Text(language).tag(language)
    }
}
.pickerStyle(.inline)
```

---

## 9. Pre-Submission Design Audit

### Visual Consistency

- [ ] Colors are consistent across all screens
- [ ] Spacing is consistent (use 8pt grid)
- [ ] Text styles are consistent

### Platform Conventions

- [ ] Dismiss button in modal is standard (X or Done)
- [ ] Settings use iOS-standard controls
- [ ] No non-standard gestures required

### Polish

- [ ] No placeholder images or text
- [ ] All states handled (empty, loading, error, content)
- [ ] Haptic feedback is appropriate (not overused)

---

## Quick Reference Links

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Accessibility in SwiftUI](https://developer.apple.com/documentation/swiftui/accessibility)
- [App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)

