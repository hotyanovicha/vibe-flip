//
//  WidgetLocalization.swift
//  VibeFlipWidget
//
//  Localization strings for the widget
//

import Foundation

struct WidgetLocalizedStrings {
    static func getText(_ key: String, language: String) -> String {
        let dict: [String: [String: String]] = [
            "challenge": [
                "Русский": "ВЫЗОВ",
                "English": "CHALLENGE",
                "Español": "DESAFÍO"
            ],
            "challenge_this_world": [
                "Русский": "Бросай вызов этому миру",
                "English": "Challenge this world",
                "Español": "Desafía este mundo"
            ],
            "your_daily_vibe": [
                "Русский": "Твой вайб дня",
                "English": "Your daily vibe",
                "Español": "Tu vibra diaria"
            ],
            "tap_to_reveal": [
                "Русский": "Нажми, чтобы открыть",
                "English": "Tap to reveal",
                "Español": "Toca para revelar"
            ],
            "quote_revealed": [
                "Русский": "Цитата открыта!",
                "English": "Quote revealed!",
                "Español": "¡Cita revelada!"
            ],
            "open_app_to_see": [
                "Русский": "Открой приложение",
                "English": "Open app to see it here",
                "Español": "Abre la app para verla"
            ],
            "daily_vibe": [
                "Русский": "Вайб дня",
                "English": "Daily Vibe",
                "Español": "Vibra Diaria"
            ],
            "widget_description": [
                "Русский": "Смотри свою мотивационную цитату дня.",
                "English": "See your daily motivation quote.",
                "Español": "Mira tu cita motivacional diaria."
            ],
            "daily_inspiration_awaits": [
                "Русский": "Твоё вдохновение ждёт...",
                "English": "Your daily inspiration awaits...",
                "Español": "Tu inspiración diaria te espera..."
            ]
        ]
        
        return dict[key]?[language] ?? dict[key]?["English"] ?? key
    }
}
