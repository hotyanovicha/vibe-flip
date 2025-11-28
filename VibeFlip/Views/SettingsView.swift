import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    
    let languages = ["Русский", "English", "Español"]
    
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
    }
}
