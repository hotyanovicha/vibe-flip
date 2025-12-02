import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    
    // Notification Settings
    @AppStorage("notificationStartHour") private var notificationStartHour = 9
    @AppStorage("notificationStartMinute") private var notificationStartMinute = 0
    @AppStorage("notificationEndHour") private var notificationEndHour = 22
    @AppStorage("notificationEndMinute") private var notificationEndMinute = 0
    @AppStorage("notificationCount") private var notificationCount = 5
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    let languages = ["Русский", "English", "Español"]
    
    // Shared defaults for widget
    private var sharedDefaults: UserDefaults? {
        #if targetEnvironment(simulator)
        return UserDefaults.standard
        #else
        return UserDefaults(suiteName: HistoryManager.appGroupIdentifier)
        #endif
    }
    
    // MARK: - Notification Computed Properties
    
    private var startTime: Date {
        get {
            var components = DateComponents()
            components.hour = notificationStartHour
            components.minute = notificationStartMinute
            return Calendar.current.date(from: components) ?? Date()
        }
    }
    
    private var endTime: Date {
        get {
            var components = DateComponents()
            components.hour = notificationEndHour
            components.minute = notificationEndMinute
            return Calendar.current.date(from: components) ?? Date()
        }
    }
    
    private var totalMinutes: Int {
        let startTotalMinutes = notificationStartHour * 60 + notificationStartMinute
        var endTotalMinutes = notificationEndHour * 60 + notificationEndMinute
        if endTotalMinutes <= startTotalMinutes {
            endTotalMinutes += 24 * 60
        }
        return endTotalMinutes - startTotalMinutes
    }
    
    private var maxNotificationCount: Int {
        max(1, (totalMinutes / 30) + 1)
    }
    
    private var intervalMinutes: Int {
        if notificationCount <= 1 {
            return totalMinutes
        }
        return totalMinutes / (notificationCount - 1)
    }
    
    private var formattedInterval: String {
        let hours = intervalMinutes / 60
        let minutes = intervalMinutes % 60
        let prefix = LocalizedStrings.getText("notification_interval_prefix", language: selectedLanguage)
        let hourSuffix = LocalizedStrings.getText("notification_hours", language: selectedLanguage)
        let minSuffix = LocalizedStrings.getText("notification_minutes", language: selectedLanguage)
        
        if hours > 0 && minutes > 0 {
            return "\(prefix)\(hours)\(hourSuffix) \(minutes)\(minSuffix)"
        } else if hours > 0 {
            return "\(prefix)\(hours)\(hourSuffix)"
        } else {
            return "\(prefix)\(minutes)\(minSuffix)"
        }
    }
    
    private var currentTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }
    
    // Compute effective color scheme for immediate update
    private var effectiveColorScheme: ColorScheme {
        switch currentTheme {
        case .system:
            return systemColorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated gradient background
                backgroundGradient
                    .ignoresSafeArea()
                
                Form {
                    // Theme Section
                    Section(header: Text(LocalizedStrings.getText("theme_section", language: selectedLanguage))) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            HStack {
                                Text(theme.localizedName(language: selectedLanguage))
                                Spacer()
                                if theme.rawValue == selectedTheme {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.purple)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTheme = theme.rawValue
                                HapticManager.shared.selection()
                            }
                        }
                    }
                    .listRowBackground(Color.clear.background(.thinMaterial))
                    
                    // Language Section
                    Section(header: Text(LocalizedStrings.getText("language_section", language: selectedLanguage))) {
                        ForEach(languages, id: \.self) { language in
                            HStack {
                                Text(language)
                                Spacer()
                                if language == selectedLanguage {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.purple)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedLanguage = language
                                saveLanguageToSharedDefaults(language)
                                HapticManager.shared.selection()
                            }
                        }
                    }
                    .listRowBackground(Color.clear.background(.thinMaterial))
                    
                    // Notifications Section
                    Section(header: Text(LocalizedStrings.getText("notifications_section", language: selectedLanguage))) {
                        // Count Row with custom stepper
                        HStack {
                            Text(LocalizedStrings.getText("notification_count", language: selectedLanguage))
                            Spacer()
                            
                            // Custom Stepper
                            HStack(spacing: 12) {
                                // Minus Button
                                Button {
                                    if notificationCount > 1 {
                                        notificationCount -= 1
                                        HapticManager.shared.selection()
                                        updateNotifications()
                                    }
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.primary)
                                        .frame(width: 32, height: 32)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 0.5
                                                )
                                        )
                                }
                                .buttonStyle(.borderless)
                                .opacity(notificationCount > 1 ? 1 : 0.4)
                                .disabled(notificationCount <= 1)
                                
                                // Count Value
                                Text("\(notificationCount)\(LocalizedStrings.getText("notification_times_suffix", language: selectedLanguage))")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .monospacedDigit()
                                    .frame(minWidth: 40)
                                    .contentTransition(.numericText())
                                    .animation(.snappy, value: notificationCount)
                                
                                // Plus Button
                                Button {
                                    if notificationCount < maxNotificationCount {
                                        notificationCount += 1
                                        HapticManager.shared.selection()
                                        updateNotifications()
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.primary)
                                        .frame(width: 32, height: 32)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 0.5
                                                )
                                        )
                                }
                                .buttonStyle(.borderless)
                                .opacity(notificationCount < maxNotificationCount ? 1 : 0.4)
                                .disabled(notificationCount >= maxNotificationCount)
                            }
                        }
                        
                        // Start Time Row
                        HStack {
                            Text(LocalizedStrings.getText("notification_start", language: selectedLanguage))
                            Spacer()
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { startTime },
                                    set: { newValue in
                                        let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                                        notificationStartHour = components.hour ?? 9
                                        notificationStartMinute = components.minute ?? 0
                                        clampNotificationCount()
                                        HapticManager.shared.selection()
                                        updateNotifications()
                                    }
                                ),
                                displayedComponents: [.hourAndMinute]
                            )
                            .labelsHidden()
                        }
                        
                        // End Time Row
                        HStack {
                            Text(LocalizedStrings.getText("notification_end", language: selectedLanguage))
                            Spacer()
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { endTime },
                                    set: { newValue in
                                        let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                                        notificationEndHour = components.hour ?? 22
                                        notificationEndMinute = components.minute ?? 0
                                        clampNotificationCount()
                                        HapticManager.shared.selection()
                                        updateNotifications()
                                    }
                                ),
                                displayedComponents: [.hourAndMinute]
                            )
                            .labelsHidden()
                        }
                        
                        // Interval Info
                        HStack {
                            Spacer()
                            Text(formattedInterval)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear.background(.thinMaterial))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitle(LocalizedStrings.getText("settings_title", language: selectedLanguage), displayMode: .inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .symbolRenderingMode(.hierarchical)
            })
        }
        .preferredColorScheme(currentTheme.colorScheme)
        .animation(.easeInOut(duration: 0.2), value: effectiveColorScheme)
        .onAppear {
            // Sync language to shared defaults on appear
            saveLanguageToSharedDefaults(selectedLanguage)
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveLanguageToSharedDefaults(_ language: String) {
        sharedDefaults?.set(language, forKey: "selectedLanguage")
        sharedDefaults?.synchronize()
        // Reload widget to reflect language change
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func clampNotificationCount() {
        if notificationCount > maxNotificationCount {
            notificationCount = maxNotificationCount
        }
        if notificationCount < 1 {
            notificationCount = 1
        }
    }
    
    private func updateNotifications() {
        NotificationManager.shared.startHour = notificationStartHour
        NotificationManager.shared.startMinute = notificationStartMinute
        NotificationManager.shared.endHour = notificationEndHour
        NotificationManager.shared.endMinute = notificationEndMinute
        NotificationManager.shared.notificationCount = notificationCount
        
        // Request permission if not already granted, then schedule
        NotificationManager.shared.checkAuthorizationStatus { authorized in
            if authorized {
                NotificationManager.shared.isEnabled = true
                NotificationManager.shared.scheduleNotifications()
            } else {
                NotificationManager.shared.requestAuthorization { granted in
                    if granted {
                        NotificationManager.shared.scheduleNotifications()
                    }
                }
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        ZStack {
            // Base
            Rectangle()
                .fill(effectiveColorScheme == .dark ? Color(white: 0.08) : Color(white: 0.96))
            
            // Floating orbs
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.purple.opacity(0.3), Color.purple.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.1)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.pink.opacity(0.25), Color.pink.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .offset(x: geo.size.width * 0.3, y: geo.size.height * 0.3)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.blue.opacity(0.2), Color.blue.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .blur(radius: 60)
        }
    }
}
