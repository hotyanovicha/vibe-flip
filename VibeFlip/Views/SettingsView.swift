import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
    
    let languages = ["Русский", "English", "Español"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("НАСТРОЕНИЕ")) {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "sparkles")
                                .font(.largeTitle)
                            Text("Дзен")
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: "flame")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Дерзкий")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section(header: Text("ЯЗЫК")) {
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
            .navigationBarTitle("Настройки", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            })
        }
    }
}
