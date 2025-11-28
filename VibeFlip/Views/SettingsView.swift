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
            Form {
                // Theme Section
                Section(header: Text(LocalizedStrings.getText("theme_section", language: selectedLanguage))) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        HStack {
                            Text(theme.localizedName(language: selectedLanguage))
                            Spacer()
                            if theme.rawValue == selectedTheme {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTheme = theme.rawValue
                            HapticManager.shared.selection()
                        }
                    }
                }
                
                // Card Style Section
                Section(header: Text(LocalizedStrings.getText("card_style_section", language: selectedLanguage))) {
                    ForEach(CardStyle.allCases, id: \.self) { cardStyle in
                        HStack {
                            Image(systemName: cardStyle.iconName)
                                .foregroundColor(.accentColor)
                                .frame(width: 24)
                            Text(cardStyle.localizedName(language: selectedLanguage))
                            Spacer()
                            if cardStyle.rawValue == selectedCardStyle {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCardStyle = cardStyle.rawValue
                            HapticManager.shared.selection()
                        }
                    }
                }
                
                // Language Section
                Section(header: Text(LocalizedStrings.getText("language_section", language: selectedLanguage))) {
                    ForEach(languages, id: \.self) { language in
                        HStack {
                            Text(language)
                            Spacer()
                            if language == selectedLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedLanguage = language
                            HapticManager.shared.selection()
                        }
                    }
                }
            }
            .navigationBarTitle(LocalizedStrings.getText("settings_title", language: selectedLanguage), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
        .preferredColorScheme(currentTheme.colorScheme)
        .animation(.easeInOut(duration: 0.2), value: effectiveColorScheme)
    }
}
