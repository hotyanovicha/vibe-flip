import Foundation

struct LocalizedStrings {
    static func getText(_ key: String, language: String) -> String {
        let dict: [String: [String: String]] = [
            "settings_title": [
                "Русский": "Настройки",
                "English": "Settings",
                "Español": "Ajustes"
            ],
            "language_section": [
                "Русский": "ЯЗЫК",
                "English": "LANGUAGE",
                "Español": "IDIOMA"
            ],
            "give_me_vibe": [
                "Русский": "Дай мне вайб",
                "English": "Give me vibe",
                "Español": "Dame vibra"
            ]
        ]
        
        return dict[key]?[language] ?? dict[key]?["English"] ?? key
    }
}
