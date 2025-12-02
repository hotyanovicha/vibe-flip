//
//  WidgetDataProvider.swift
//  VibeFlipWidget
//
//  Created by Alex Hotyanovich on 12/1/25.
//

import Foundation

/// Shared data provider for widget to access quote data
struct WidgetDataProvider {
    static let appGroupIdentifier = "group.com.vibeflip.shared"
    
    private static let widgetQuoteKey = "widgetQuote"
    private static let widgetQuoteDateKey = "widgetQuoteDate"
    private static let widgetActionKey = "widgetAction"
    private static let shownCardsKey = "shownCards"
    private static let selectedLanguageKey = "selectedLanguage"
    
    private static var sharedDefaults: UserDefaults? {
        #if targetEnvironment(simulator)
        // Use standard UserDefaults in simulator if App Group causes issues
        return UserDefaults.standard
        #else
        return UserDefaults(suiteName: appGroupIdentifier)
        #endif
    }
    
    /// Get today's quote data for widget display
    /// Checks both widget-specific data and history data
    static func getTodayQuote() -> WidgetQuoteData? {
        guard let defaults = sharedDefaults else {
            return nil
        }
        
        let todayKey = dateKey(for: Date())
        
        // Check if we have widget-specific quote saved for today
        let savedDate = defaults.string(forKey: widgetQuoteDateKey)
        let savedText = defaults.string(forKey: widgetQuoteKey)
        
        if savedDate == todayKey, let text = savedText {
            let action = defaults.string(forKey: widgetActionKey)
            return WidgetQuoteData(text: text, action: action)
        }
        
        // Also check if quote was opened today (even if widget data wasn't saved)
        if let shownCards = defaults.dictionary(forKey: shownCardsKey) as? [String: String],
           shownCards[todayKey] != nil {
            return nil
        }
        
        return nil
    }
    
    /// Check if today's quote has been revealed (opened in the app)
    static func isTodayQuoteRevealed() -> Bool {
        let todayKey = dateKey(for: Date())
        
        // Check widget-specific data
        if let savedDate = sharedDefaults?.string(forKey: widgetQuoteDateKey),
           savedDate == todayKey {
            return true
        }
        
        // Check history data
        if let shownCards = sharedDefaults?.dictionary(forKey: shownCardsKey) as? [String: String],
           shownCards[todayKey] != nil {
            return true
        }
        
        return false
    }
    
    /// Get the currently selected language from shared settings
    /// Falls back to system language detection if not set
    static func getCurrentLanguage() -> String {
        if let language = sharedDefaults?.string(forKey: selectedLanguageKey) {
            return language
        }
        
        // Fallback: detect from system language
        return detectSystemLanguage()
    }
    
    /// Detect system language and return matching app language
    private static func detectSystemLanguage() -> String {
        let preferredLanguages = Locale.preferredLanguages
        let languageCodeMapping: [String: String] = [
            "en": "English",
            "ru": "Русский",
            "es": "Español"
        ]
        
        for preferredLanguage in preferredLanguages {
            let languageCode = String(preferredLanguage.prefix(2))
            if let mappedLanguage = languageCodeMapping[languageCode] {
                return mappedLanguage
            }
        }
        
        return "English"
    }
    
    private static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

/// Data model for widget quote display
struct WidgetQuoteData {
    let text: String
    let action: String?
}

// MARK: - Widget Localization Strings

/// Localized strings for widget UI elements
struct WidgetStrings {
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
