import Foundation
import Combine

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    
    @Published var openedDates: Set<String> = []
    
    private let userDefaultsKey = "openedDates"
    
    private init() {
        load()
    }
    
    func markAsOpened(date: Date) {
        let key = dateKey(for: date)
        if !openedDates.contains(key) {
            openedDates.insert(key)
            save()
        }
    }
    
    func isOpened(date: Date) -> Bool {
        return openedDates.contains(dateKey(for: date))
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func save() {
        let array = Array(openedDates)
        UserDefaults.standard.set(array, forKey: userDefaultsKey)
    }
    
    private func load() {
        if let array = UserDefaults.standard.stringArray(forKey: userDefaultsKey) {
            openedDates = Set(array)
        }
    }
}
