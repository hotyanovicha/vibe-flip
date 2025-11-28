import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
    
    let languages = ["Русский", "English", "Español"]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text(LocalizedStrings.getText("language_section", language: selectedLanguage))) {
                    ForEach(languages, id: \.self) { language in
                        HStack {
                            Text(language)
                            Spacer()
                            if language == selectedLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.black)
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
                    .foregroundColor(.black)
            })
        }
    }
}
