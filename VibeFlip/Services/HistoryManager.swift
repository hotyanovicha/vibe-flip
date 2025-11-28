import Foundation
import Combine

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    
    // DateString -> CardID
    @Published var shownCards: [String: String] = [:]
    
    private let userDefaultsKey = "shownCards"
    
    private init() {
        load()
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
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func save() {
        UserDefaults.standard.set(shownCards, forKey: userDefaultsKey)
    }
    
    private func load() {
        if let dict = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] {
            shownCards = dict
        }
    }
    
    // Backward compatibility for migration if needed, but for now we start fresh or ignore old boolean-only history
    // If we needed to migrate, we would read the old "openedDates" key.
}
