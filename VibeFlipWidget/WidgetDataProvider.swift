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
    
    private static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
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
