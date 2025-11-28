import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    @AppStorage("selectedCardStyle") private var selectedCardStyle = CardStyle.classic.rawValue
    
    let languages = ["Русский", "English", "Español"]
    
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
                    
                    // Card Style Section
                    Section(header: Text(LocalizedStrings.getText("card_style_section", language: selectedLanguage))) {
                        ForEach(CardStyle.allCases, id: \.self) { cardStyle in
                            HStack {
                                Image(systemName: cardStyle.iconName)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 24)
                                Text(cardStyle.localizedName(language: selectedLanguage))
                                Spacer()
                                if cardStyle.rawValue == selectedCardStyle {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.purple)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCardStyle = cardStyle.rawValue
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
                                HapticManager.shared.selection()
                            }
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
