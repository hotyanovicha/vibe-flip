import Foundation

struct MotivationCard: Identifiable, Codable {
    let id: String
    let text: String
    let action: String?
    let category: CardCategory
    
    enum CardCategory: String, Codable {
        case zen
        case bold
    }
}
