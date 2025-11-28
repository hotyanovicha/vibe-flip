# Marketing Guidelines for VibeFlip

This document covers Apple's marketing requirements for promoting VibeFlip on the App Store and in external marketing materials.

> Reference: [App Store Marketing Resources and Identity Guidelines](https://developer.apple.com/app-store/marketing/guidelines/)

---

## 1. App Store Badges

Use App Store badges as a call-to-action in all marketing materials to direct users to download your app.

### Download Badges

Access official badge artwork:
- [App Store Marketing Tools](https://tools.applemediaservices.com/app-store/)
- [Download All Badge Artwork](https://developer.apple.com/app-store/marketing/guidelines/#badges)

### Badge Types

| Badge Type | When to Use |
|------------|-------------|
| **Preferred (Black)** | Default choice for all marketing materials |
| **Alternative (White)** | When black badge looks too heavy in layout |
| **Pre-order** | Only during pre-order period |
| **Download** | After app is released |

### Badge Rules

| Rule | Requirement |
|------|-------------|
| Minimum height (print) | 10mm |
| Minimum height (screen) | 40px |
| Clear space | 1/4 of badge height on all sides |
| Modifications | **Not allowed** - no shadows, reflections, or color changes |
| Animation | **Not allowed** |
| Position | Subordinate to main message (not dominant) |

### Localized Badges

VibeFlip supports English, Russian, and Spanish. Use localized badges:

| Language | Badge Text |
|----------|------------|
| English | "Download on the App Store" |
| Russian (Pусский) | "Загрузите в App Store" |
| Spanish (Español) | "Descárgalo en el App Store" |

**Important**: "App Store" always remains in English. Never translate "App Store".

### Badge Placement

```
✓ DO:
- Place badge below or beside main marketing message
- Use one badge per layout
- Link badge to your App Store page

✗ DON'T:
- Make badge the dominant artwork
- Use multiple badges in one layout
- Modify badge colors or shape
- Animate the badge
```

---

## 2. Apple Product Images

When showing VibeFlip on Apple devices in marketing materials, use official Apple product bezels.

### Download Product Bezels

[Download Apple Product Bezels](https://developer.apple.com/app-store/marketing/guidelines/#products)

### Approved Device Images

| Device | Use For |
|--------|---------|
| iPhone 15 Pro | Premium marketing materials |
| iPhone 15 | General marketing |
| iPhone SE | Budget-conscious audience |

**Always use latest-generation devices** for which your app is developed.

### Product Image Rules

| Allowed ✓ | Not Allowed ✗ |
|-----------|---------------|
| Official Apple bezels only | Custom device renders |
| "As is" without modification | Adding shadows/reflections |
| Promotional copy beside device | Text overlaying device |
| Current-generation devices | Outdated device models |

### Screen Content Requirements

When showing VibeFlip on a device:

- [ ] Display app as it appears when running
- [ ] Show actual app screens (not mockups)
- [ ] Use latest iOS version appearance
- [ ] Never show blank screens
- [ ] Status bar must show:
  - Full network/cellular icon
  - Full Wi-Fi icon
  - Full battery icon

### Minimum Device Sizes

| Medium | Minimum Size |
|--------|--------------|
| Print | 25mm height |
| Screen | 200px height |

---

## 3. Screenshots and App Previews

### App Store Screenshot Requirements

| Device | Required Sizes |
|--------|----------------|
| iPhone 6.7" (required) | 1290 × 2796 px |
| iPhone 6.5" (required) | 1242 × 2688 px |
| iPhone 5.5" (optional) | 1242 × 2208 px |

### Screenshot Content for VibeFlip

Recommended screenshot sequence:

| # | Screen | Purpose |
|---|--------|---------|
| 1 | Home with "Give me vibe" button | Show main interaction |
| 2 | Revealed motivational card | Core value proposition |
| 3 | Card with action suggestion | Show additional value |
| 4 | Settings (themes) | Customization options |
| 5 | Dark mode view | Aesthetic appeal |

### Screenshot Best Practices

- [ ] Show real app screens (not mockups with fake content)
- [ ] Include device frames for polish (optional)
- [ ] Add marketing text overlays sparingly
- [ ] Ensure text is readable at thumbnail size
- [ ] Use consistent style across all screenshots

### App Preview Video (Optional)

| Specification | Requirement |
|---------------|-------------|
| Duration | 15-30 seconds |
| Format | H.264, up to 30fps |
| Resolution | Match screenshot dimensions |
| Audio | Optional (muted by default) |

**Video Content Ideas:**
1. Tap "Give me vibe" button
2. Card reveal animation
3. Swipe through multiple cards
4. Theme switching demonstration

---

## 4. Messaging Guidelines

### Product Names

| Correct ✓ | Incorrect ✗ |
|-----------|-------------|
| App Store | AppStore, app store, Appstore |
| iPhone | I-phone, i-Phone, IPHONE |
| iOS | IOS, ios |
| Apple | apple, APPLE |

### Trademark Attribution

Include this in marketing materials (fine print):

```
Apple, the Apple logo, iPhone, and App Store are trademarks of 
Apple Inc., registered in the U.S. and other countries.
```

### Messaging Dos and Don'ts

| Do ✓ | Don't ✗ |
|------|---------|
| "Available on the App Store" | "Available on Apple App Store" |
| "Download on the App Store" | "Buy on the App Store" (for free apps) |
| "VibeFlip for iPhone" | "VibeFlip for Apple iPhone" |
| Use App Store badge | Use Apple logo alone |

### Sample Marketing Copy

```
VibeFlip - Daily Motivation

Start each day with intention. VibeFlip delivers one curated 
motivational message daily, paired with a simple action to 
transform your mindset.

Features:
• Daily motivational cards with actionable suggestions
• Available in English, Russian, and Spanish
• Beautiful light and dark themes
• 100% offline - your data stays on your device

Download on the App Store
```

---

## 5. Social Media Marketing

### Platform-Specific Guidance

| Platform | Best Practice |
|----------|---------------|
| Instagram | Use device mockups with App Store badge |
| Twitter/X | Short message + App Store link |
| Facebook | Carousel showing app features |
| TikTok | Screen recording of card reveals |

### Hashtag Suggestions

```
#VibeFlip #DailyMotivation #MindfulnessApp #iOSApp 
#MotivationalQuotes #SelfImprovement #Wellness
```

### Social Media Image Sizes

| Platform | Recommended Size |
|----------|------------------|
| Instagram Post | 1080 × 1080 px |
| Instagram Story | 1080 × 1920 px |
| Twitter/X | 1200 × 675 px |
| Facebook | 1200 × 630 px |

---

## 6. Website Marketing

### App Store Badge Embed Code

Generate embeddable code at: [App Store Marketing Tools](https://tools.applemediaservices.com/app-store/)

Example embed:

```html
<a href="https://apps.apple.com/app/vibeflip/id[YOUR_APP_ID]">
  <img src="Download_on_the_App_Store_Badge.svg" 
       alt="Download VibeFlip on the App Store"
       style="height: 40px;">
</a>
```

### Smart App Banner

Add to your website's `<head>`:

```html
<meta name="apple-itunes-app" content="app-id=[YOUR_APP_ID]">
```

This shows a banner to iOS Safari users prompting them to download.

---

## 7. Legal Requirements

### Required Disclosures

For all marketing materials:

- [ ] Apple trademark attribution (see Section 4)
- [ ] No implication of Apple endorsement
- [ ] No use of Apple logo without badge context
- [ ] Accurate app functionality claims

### Photography and Video

If creating promotional content:

- [ ] Own all rights to screen content
- [ ] Use fictional account information (not real user data)
- [ ] Don't show real people without consent
- [ ] Don't imply celebrity endorsement

### Prohibited Uses

| Never Do This |
|---------------|
| Use Apple logo standalone (without badge) |
| Create 3D renders of Apple products |
| Put App Store badge on food packaging |
| Put App Store badge on vehicle decals/magnets |
| Illustrate Apple products (use official bezels only) |
| Animate Apple product images |

---

## 8. Marketing Launch Checklist

### Pre-Launch

- [ ] App Store listing complete with screenshots
- [ ] App Preview video uploaded (optional)
- [ ] Privacy policy URL active
- [ ] Social media accounts created
- [ ] Press kit prepared

### Launch Day

- [ ] App approved and released
- [ ] Social media announcements scheduled
- [ ] App Store link tested and working
- [ ] Badge code generated for website

### Post-Launch

- [ ] Respond to App Store reviews
- [ ] Monitor download analytics
- [ ] Collect user feedback for improvements
- [ ] Plan feature updates

---

## 9. Marketing Assets Checklist

### Required Assets

| Asset | Status |
|-------|--------|
| App Icon (1024×1024) | [ ] Created |
| Screenshots (all sizes) | [ ] Created |
| App Store description | [ ] Written |
| Keywords (100 chars) | [ ] Researched |
| Privacy Policy URL | [ ] Published |

### Recommended Assets

| Asset | Status |
|-------|--------|
| App Preview video | [ ] Created |
| Press kit (zip) | [ ] Prepared |
| Social media graphics | [ ] Designed |
| Website landing page | [ ] Built |
| Email announcement | [ ] Drafted |

---

## Quick Reference Links

- [App Store Marketing Tools](https://tools.applemediaservices.com/app-store/)
- [Marketing Resources and Identity Guidelines](https://developer.apple.com/app-store/marketing/guidelines/)
- [App Store Badge Downloads](https://developer.apple.com/app-store/marketing/guidelines/#badges)
- [Apple Product Bezels](https://developer.apple.com/app-store/marketing/guidelines/#products)
- [Apple Trademark List](https://www.apple.com/legal/intellectual-property/trademark/appletmlist.html)
- [Guidelines for Using Apple Trademarks](https://www.apple.com/legal/intellectual-property/guidelinesfor3rdparties.html)

