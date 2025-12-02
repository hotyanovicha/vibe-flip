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
            ],
            "challenge": [
                "Русский": "ВЫЗОВ",
                "English": "CHALLENGE",
                "Español": "DESAFÍO"
            ],
            "settings_accessibility": [
                "Русский": "Настройки",
                "English": "Settings",
                "Español": "Ajustes"
            ],
            "card_accessibility_hint": [
                "Русский": "Открывает мотивационную карточку дня",
                "English": "Reveals today's motivational card",
                "Español": "Revela la tarjeta motivacional del día"
            ],
            // Card Style Localization
            "card_style_section": [
                "Русский": "СТИЛЬ КАРТОЧКИ",
                "English": "CARD STYLE",
                "Español": "ESTILO DE TARJETA"
            ],
            "card_style_classic": [
                "Русский": "Классический",
                "English": "Classic",
                "Español": "Clásico"
            ],
            "card_style_gradient": [
                "Русский": "Градиент",
                "English": "Gradient",
                "Español": "Gradiente"
            ],
            "one_more_please": [
                "Русский": "Ещё одну",
                "English": "One more please",
                "Español": "Una más"
            ],
            // Notification Settings
            "notifications_section": [
                "Русский": "УВЕДОМЛЕНИЯ",
                "English": "NOTIFICATIONS",
                "Español": "NOTIFICACIONES"
            ],
            "notification_count": [
                "Русский": "Количество",
                "English": "Count",
                "Español": "Cantidad"
            ],
            "notification_start": [
                "Русский": "Начало",
                "English": "Start",
                "Español": "Inicio"
            ],
            "notification_end": [
                "Русский": "Окончание",
                "English": "End",
                "Español": "Fin"
            ],
            "notification_times_suffix": [
                "Русский": "×",
                "English": "×",
                "Español": "×"
            ],
            "notification_interval_prefix": [
                "Русский": "Каждые ~",
                "English": "Every ~",
                "Español": "Cada ~"
            ],
            "notification_hours": [
                "Русский": "ч",
                "English": "h",
                "Español": "h"
            ],
            "notification_minutes": [
                "Русский": "мин",
                "English": "min",
                "Español": "min"
            ],
            // Widget Localization
            "widget_daily_vibe": [
                "Русский": "Твой вайб дня",
                "English": "Your daily vibe",
                "Español": "Tu vibra diaria"
            ],
            "widget_tap_to_reveal": [
                "Русский": "Нажми, чтобы открыть",
                "English": "Tap to reveal",
                "Español": "Toca para revelar"
            ],
            "widget_quote_revealed": [
                "Русский": "Цитата открыта!",
                "English": "Quote revealed!",
                "Español": "¡Cita revelada!"
            ],
            "widget_open_app": [
                "Русский": "Открой приложение",
                "English": "Open app to see it here",
                "Español": "Abre la app para verla"
            ],
            "widget_display_name": [
                "Русский": "Вайб дня",
                "English": "Daily Vibe",
                "Español": "Vibra Diaria"
            ],
            "widget_description": [
                "Русский": "Твоя ежедневная мотивационная цитата.",
                "English": "See your daily motivation quote.",
                "Español": "Ve tu cita motivacional diaria."
            ]
        ]
        
        return dict[key]?[language] ?? dict[key]?["English"] ?? key
    }
}

// MARK: - Widget Localization Helper
// This is a duplicate for widget target since widgets can't access main app code

struct WidgetLocalizedStrings {
    static func getText(_ key: String, language: String) -> String {
        let dict: [String: [String: String]] = [
            "challenge": [
                "Русский": "ВЫЗОВ",
                "English": "CHALLENGE",
                "Español": "DESAFÍO"
            ],
            "widget_daily_vibe": [
                "Русский": "Твой вайб дня",
                "English": "Your daily vibe",
                "Español": "Tu vibra diaria"
            ],
            "widget_tap_to_reveal": [
                "Русский": "Нажми, чтобы открыть",
                "English": "Tap to reveal",
                "Español": "Toca para revelar"
            ],
            "widget_quote_revealed": [
                "Русский": "Цитата открыта!",
                "English": "Quote revealed!",
                "Español": "¡Cita revelada!"
            ],
            "widget_open_app": [
                "Русский": "Открой приложение",
                "English": "Open app to see it here",
                "Español": "Abre la app para verla"
            ],
            "widget_display_name": [
                "Русский": "Вайб дня",
                "English": "Daily Vibe",
                "Español": "Vibra Diaria"
            ],
            "widget_description": [
                "Русский": "Твоя ежедневная мотивационная цитата.",
                "English": "See your daily motivation quote.",
                "Español": "Ve tu cita motivacional diaria."
            ]
        ]
        
        return dict[key]?[language] ?? dict[key]?["English"] ?? key
    }
}
