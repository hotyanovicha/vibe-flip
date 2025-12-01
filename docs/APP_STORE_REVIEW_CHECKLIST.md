# App Store Review Checklist for VibeFlip

This checklist covers the key App Store Review Guidelines requirements for VibeFlip before submission.

> Reference: [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

## 1. App Completeness (Guideline 2.1)

Before submitting, ensure the app is complete and fully functional:

- [ ] App launches without crashing on all supported iOS versions
- [ ] All buttons and interactive elements work correctly
- [ ] "Give me vibe" button successfully displays a motivational card
- [ ] Settings sheet opens and closes properly
- [ ] Theme switching (Light/Dark/System) works correctly
- [ ] Language switching updates all UI text and card content
- [ ] Card history tracking works across app restarts
- [ ] No placeholder content or "coming soon" features

### Testing Requirements

| Device Type | iOS Version | Status |
|-------------|-------------|--------|
| iPhone SE (3rd gen) | iOS 15+ | [ ] Tested |
| iPhone 14/15 | iOS 17+ | [ ] Tested |
| iPhone Pro Max | iOS 17+ | [ ] Tested |

---

## 2. Minimum Functionality (Guideline 4.2)

Apps must provide lasting value beyond a simple website or basic utility.

### VibeFlip Value Proposition

| Feature | Description | Value |
|---------|-------------|-------|
| Daily Motivation | New card each day with 30-day rotation | Sustained engagement |
| Action Suggestions | Practical actions paired with quotes | Actionable wellness |
| Multi-Language | English, Russian, Spanish support | Global accessibility |
| Theme Support | Light/Dark/System modes | User preference |
| Haptic Feedback | Tactile interaction responses | Premium feel |
| Offline-First | No internet required | Always available |

### Ensure Your App Is NOT:

- [ ] A simple web view wrapper
- [ ] A duplicate of existing functionality on iOS
- [ ] An app with minimal or no functionality
- [ ] A "demo" or "trial" version

---

## 3. Spam and Duplicate Apps (Guideline 4.3)

Ensure VibeFlip offers unique value:

- [ ] App has unique branding and visual identity
- [ ] Content is original (not copied from other apps)
- [ ] Not publishing multiple similar apps
- [ ] App name is not misleading or keyword-stuffed

### Differentiation Points

Document what makes VibeFlip unique:

1. **Curated Content**: 70 hand-selected motivational messages with actions
2. **Daily Discovery**: One card per day encourages mindful engagement
3. **Multi-Language**: Native content in 3 languages (not auto-translated)
4. **Privacy-Focused**: Fully offline, no data collection

---

## 4. Metadata Requirements

### App Store Connect Fields

| Field | Requirement | VibeFlip Status |
|-------|-------------|-----------------|
| App Name | Unique, descriptive, ≤30 chars | [ ] Ready |
| Subtitle | Brief description, ≤30 chars | [ ] Ready |
| Description | Accurate features, no keywords | [ ] Ready |
| Keywords | 100 char limit, comma-separated | [ ] Ready |
| Category | Primary: Lifestyle or Health & Fitness | [ ] Selected |
| Age Rating | 4+ (no objectionable content) | [ ] Set |
| Privacy Policy URL | Required (see PRIVACY_REQUIREMENTS.md) | [ ] Added |

### Screenshots Required

| Device | Requirement |
|--------|-------------|
| iPhone 6.7" | 3-10 screenshots required |
| iPhone 6.5" | 3-10 screenshots required |
| iPhone 5.5" | Optional (recommended) |

**Screenshot Content Suggestions:**
1. Home screen with "Give me vibe" button
2. Revealed motivational card with action
3. Settings screen showing theme/language options
4. Card in dark mode

### App Preview Video (Optional)

- Duration: 15-30 seconds
- Show the card reveal animation
- Demonstrate theme switching

---

## 5. Pre-Submission Testing Checklist

### Functionality

- [ ] Fresh install works correctly
- [ ] App state persists after force quit
- [ ] Works in airplane mode (offline)
- [ ] All 3 languages display correctly
- [ ] Cards rotate properly (not same card every day)
- [ ] History persists across 30+ days

### UI/UX

- [ ] No UI clipping on small screens
- [ ] No UI clipping on large screens
- [ ] Dynamic Type support (accessibility)
- [ ] VoiceOver works correctly
- [ ] Dark mode displays properly
- [ ] Light mode displays properly

### Performance

- [ ] App launches in < 2 seconds
- [ ] No memory leaks during extended use
- [ ] Animations are smooth (60fps)
- [ ] No excessive battery drain

---

## 6. Common Rejection Reasons to Avoid

| Rejection Reason | How to Avoid |
|------------------|--------------|
| Crashes | Test on multiple devices |
| Broken links | Ensure privacy policy URL works |
| Incomplete metadata | Fill all required fields |
| Placeholder content | Remove all "lorem ipsum" |
| Missing privacy policy | Add valid URL (see PRIVACY_REQUIREMENTS.md) |
| Guideline 4.2 (limited functionality) | Document app value clearly |

---

## 7. App Store Connect Submission Steps

1. [ ] Create App Record in App Store Connect
2. [ ] Upload build from Xcode
3. [ ] Fill in all metadata
4. [ ] Upload screenshots for all required sizes
5. [ ] Set pricing (Free)
6. [ ] Add Privacy Policy URL
7. [ ] Complete App Privacy questionnaire
8. [ ] Submit for Review
9. [ ] Respond promptly to any review questions

---

## Quick Reference Links

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Screenshot Specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications)


