import Foundation

class DailyProvider {
    static let shared = DailyProvider()
    
    private var cards: [String: [MotivationCard]] = [:]
    
    private init() {
        loadCards()
    }
    
    private func loadCards() {
        guard let url = Bundle.main.url(forResource: "motivation_cards", withExtension: "json") else {
            print("Error: motivation_cards.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            cards = try JSONDecoder().decode([String: [MotivationCard]].self, from: data)
        } catch {
            print("Error decoding motivation_cards.json: \(error)")
        }
    }
    
    func getCard(for date: Date, language: String = "English") -> MotivationCard {
        let localizedCards = cards[language] ?? cards["English"] ?? []
        
        if localizedCards.isEmpty {
            // Fallback if something goes wrong with loading
            return MotivationCard(id: "fallback", text: "Welcome to VibeFlip", action: nil, category: .zen)
        }
        
        // 1. Check if a card was already assigned for this date
        if let assignedId = HistoryManager.shared.getCardId(for: date) {
            if let card = localizedCards.first(where: { $0.id == assignedId }) {
                return card
            }
        }
        
        // 2. If not assigned, pick a new one
        // Filter out cards shown in the last 30 days
        let recentIds = HistoryManager.shared.getRecentlyShownCardIds(days: 30)
        let availableCards = localizedCards.filter { !recentIds.contains($0.id) }
        
        // If all cards were shown recently (unlikely with 70 cards and 30 days), reset pool
        let pool = availableCards.isEmpty ? localizedCards : availableCards
        
        // Pick a random card
        // Use a seed based on date to ensure stability if called multiple times for same date without history update (though history update handles it)
        // But better to just use random element since we save it immediately.
        let card = pool.randomElement() ?? localizedCards[0]
        
        // 3. Save the assignment
        HistoryManager.shared.markAsOpened(date: date, cardId: card.id)
        
        return card
    }
}
