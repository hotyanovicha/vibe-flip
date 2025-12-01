import Foundation
import Combine
import WidgetKit

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    
    // App Group identifier for sharing data with widget
    static let appGroupIdentifier = "group.com.vibeflip.shared"
    
    // DateString -> CardID
    @Published var shownCards: [String: String] = [:]
    
    private let userDefaultsKey = "shownCards"
    private let widgetQuoteKey = "widgetQuote"
    private let widgetQuoteDateKey = "widgetQuoteDate"
    private let widgetActionKey = "widgetAction"
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: HistoryManager.appGroupIdentifier)
    }
    
    private init() {
        load()
        migrateToAppGroup()
    }
    
    func markAsOpened(date: Date, cardId: String) {
        let key = dateKey(for: date)
        if shownCards[key] == nil {
            shownCards[key] = cardId
            save()
        }
    }
    
    func isOpened(date: Date) -> Bool {
        return shownCards[dateKey(for: date)] != nil
    }
    
    func getCardId(for date: Date) -> String? {
        return shownCards[dateKey(for: date)]
    }
    
    func getRecentlyShownCardIds(days: Int) -> Set<String> {
        let calendar = Calendar.current
        let today = Date()
        var ids = Set<String>()
        
        for i in 0..<days {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let key = dateKey(for: date)
                if let id = shownCards[key] {
                    ids.insert(id)
                }
            }
        }
        return ids
    }
    
    // MARK: - Widget Data
    
    /// Save quote data for widget display
    func saveQuoteForWidget(text: String, action: String?, date: Date) {
        guard let defaults = sharedDefaults else {
            print("⚠️ VibeFlip: App Group not configured! Widget won't work.")
            return
        }
        
        defaults.set(text, forKey: widgetQuoteKey)
        defaults.set(dateKey(for: date), forKey: widgetQuoteDateKey)
        if let action = action {
            defaults.set(action, forKey: widgetActionKey)
        } else {
            defaults.removeObject(forKey: widgetActionKey)
        }
        defaults.synchronize()
        
        print("✅ VibeFlip: Quote saved for widget - \(text.prefix(30))...")
        
        // Reload widget timelines
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Get today's quote for widget (returns nil if no quote opened today)
    func getWidgetQuote() -> (text: String, action: String?)? {
        guard let savedDate = sharedDefaults?.string(forKey: widgetQuoteDateKey),
              savedDate == dateKey(for: Date()),
              let text = sharedDefaults?.string(forKey: widgetQuoteKey) else {
            return nil
        }
        let action = sharedDefaults?.string(forKey: widgetActionKey)
        return (text, action)
    }
    
    /// Check if quote was opened today (for widget)
    func isTodayQuoteOpened() -> Bool {
        guard let savedDate = sharedDefaults?.string(forKey: widgetQuoteDateKey) else {
            return false
        }
        return savedDate == dateKey(for: Date())
    }
    
    // MARK: - Private
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func save() {
        sharedDefaults?.set(shownCards, forKey: userDefaultsKey)
        sharedDefaults?.synchronize()
        
        // Also save to standard defaults as backup
        UserDefaults.standard.set(shownCards, forKey: userDefaultsKey)
    }
    
    private func load() {
        // Try shared defaults first, then fall back to standard
        if let dict = sharedDefaults?.dictionary(forKey: userDefaultsKey) as? [String: String] {
            shownCards = dict
        } else if let dict = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] {
            shownCards = dict
        }
    }
    
    /// Migrate existing data from standard UserDefaults to App Group
    private func migrateToAppGroup() {
        let migrationKey = "didMigrateToAppGroup"
        
        guard sharedDefaults?.bool(forKey: migrationKey) != true else { return }
        
        // Copy data from standard defaults to shared defaults
        if let dict = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] {
            sharedDefaults?.set(dict, forKey: userDefaultsKey)
            sharedDefaults?.set(true, forKey: migrationKey)
            sharedDefaults?.synchronize()
        }
    }
}
