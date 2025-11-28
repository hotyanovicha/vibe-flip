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
            "theme_section": [
                "Русский": "ТЕМА",
                "English": "THEME",
                "Español": "TEMA"
            ],
            "theme_system": [
                "Русский": "Системная",
                "English": "System",
                "Español": "Sistema"
            ],
            "theme_light": [
                "Русский": "Светлая",
                "English": "Light",
                "Español": "Clara"
            ],
            "theme_dark": [
                "Русский": "Тёмная",
                "English": "Dark",
                "Español": "Oscura"
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
