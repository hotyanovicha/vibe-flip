# Privacy Requirements for VibeFlip

This document covers privacy compliance requirements for App Store submission.

> Reference: [App Store Review Guidelines - Section 5.1](https://developer.apple.com/app-store/review/guidelines/#privacy)

---

## 1. Privacy Policy Requirement (Guideline 5.1.1)

**All apps submitted to the App Store must have a privacy policy**, even if they don't collect user data.

### Required Privacy Policy URL

You must provide a publicly accessible privacy policy URL in:
- App Store Connect (App Information > Privacy Policy URL)
- Within the app (recommended in Settings)

### Privacy Policy Template for VibeFlip

Since VibeFlip is a privacy-friendly app with minimal data usage, here's a template:

```
VIBEFLIP PRIVACY POLICY

Last Updated: [DATE]

1. OVERVIEW
VibeFlip is designed with your privacy in mind. We do not collect, 
store, or transmit any personal information to external servers.

2. DATA WE COLLECT
We do NOT collect:
- Personal information
- Usage analytics
- Location data
- Device identifiers
- Any data transmitted over the internet

3. LOCAL DATA STORAGE
The app stores the following data locally on your device only:
- Your theme preference (Light/Dark/System)
- Your language preference
- Card viewing history (to avoid repeating cards)

This data:
- Never leaves your device
- Is not accessible to us or any third party
- Can be deleted by uninstalling the app

4. THIRD-PARTY SERVICES
VibeFlip does not use any third-party services, analytics, 
or advertising SDKs.

5. CHILDREN'S PRIVACY
VibeFlip does not collect data from anyone, including children 
under 13. The app is safe for all ages.

6. CHANGES TO THIS POLICY
We may update this policy. Changes will be reflected in the 
"Last Updated" date above.

7. CONTACT
[Your contact email]
```

### Where to Host Your Privacy Policy

Options for hosting:
1. **GitHub Pages** - Free, easy to update
2. **Your own website** - Full control
3. **Notion** - Free, public pages available
4. **Google Sites** - Free, simple

---

## 2. App Privacy Details (Nutrition Label)

Starting December 2020, Apple requires all apps to declare their privacy practices in App Store Connect. This appears as a "App Privacy" section on your App Store listing.

### VibeFlip Data Declaration

Since VibeFlip doesn't collect data, your declaration should be:

| Question | Answer for VibeFlip |
|----------|---------------------|
| "Does this app collect data?" | **No** |
| Data linked to user | None |
| Data used to track user | None |
| Data collected | None |

### App Store Connect Steps

1. Go to **App Store Connect** > Your App > **App Privacy**
2. Click **Get Started**
3. When asked "Do you or your third-party partners collect data from this app?", select **No**
4. Save and submit

This will display: **"No Data Collected"** on your App Store listing.

---

## 3. Local Data Storage Details

### What VibeFlip Stores Locally

| Data | Storage Method | Purpose |
|------|----------------|---------|
| `selectedLanguage` | `@AppStorage` (UserDefaults) | Remember language preference |
| `selectedTheme` | `@AppStorage` (UserDefaults) | Remember theme preference |
| Card history | `HistoryManager` (UserDefaults) | Avoid repeating recent cards |

### Code Reference

```swift
// From SettingsView.swift
@AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
@AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
```

### Data Lifecycle

- **Created**: When user changes settings
- **Updated**: When preferences change
- **Deleted**: When app is uninstalled
- **Transmitted**: Never (fully offline)

---

## 4. Privacy Manifest (iOS 17+)

Starting Spring 2024, Apple requires a **Privacy Manifest** (`PrivacyInfo.xcprivacy`) for apps using certain APIs.

### Required API Declarations for VibeFlip

VibeFlip uses `UserDefaults` which requires declaration:

#### Create `PrivacyInfo.xcprivacy`

Add this file to your Xcode project:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array/>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### Explanation

| Key | Value | Meaning |
|-----|-------|---------|
| `NSPrivacyTracking` | `false` | App doesn't track users |
| `NSPrivacyTrackingDomains` | Empty | No tracking domains |
| `NSPrivacyCollectedDataTypes` | Empty | No data collected |
| `NSPrivacyAccessedAPITypes` | UserDefaults | Declares use of UserDefaults |
| Reason `CA92.1` | - | "Access to user defaults to read/write data within the app" |

### Adding to Xcode

1. In Xcode, right-click on `VibeFlip` folder
2. Select **New File...**
3. Choose **App Privacy** (under Resource section)
4. Name it `PrivacyInfo`
5. Configure as shown above

---

## 5. Compliance Checklist

### Before Submission

- [ ] Privacy policy created and hosted at public URL
- [ ] Privacy policy URL added to App Store Connect
- [ ] App Privacy questionnaire completed in App Store Connect
- [ ] `PrivacyInfo.xcprivacy` added to Xcode project
- [ ] No third-party SDKs requiring additional declarations

### Privacy-Friendly Features to Highlight

In your App Store description, consider mentioning:
- "100% offline - no internet required"
- "No data collection"
- "No ads or tracking"
- "Your preferences stay on your device"

---

## 6. GDPR and International Compliance

Although VibeFlip doesn't collect data, be aware of:

### GDPR (EU)
- No action required since no personal data is collected
- Privacy policy should state this clearly

### CCPA (California)
- No action required since no personal data is sold
- Privacy policy covers this

### COPPA (Children - US)
- No action required since no data is collected from anyone
- App is safe for age rating 4+

---

## Quick Reference Links

- [App Privacy Details on App Store](https://developer.apple.com/app-store/app-privacy-details/)
- [Privacy Manifest Documentation](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)
- [Required Reason APIs](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api)
- [User Defaults API Declaration](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api#4278393)


