import Foundation

class DailyProvider {
    static let shared = DailyProvider()
    
    private let cards: [String: [MotivationCard]] = [
        "Русский": [
            MotivationCard(id: "1", text: "Твоя энергия — твой самый ценный ресурс.", action: "Отдохни 10 минут без телефона.", category: .zen),
            MotivationCard(id: "2", text: "Сделай то, что давно откладывал.", action: "Начни прямо сейчас, хотя бы 5 минут.", category: .bold),
            MotivationCard(id: "3", text: "Улыбнись незнакомцу.", action: nil, category: .zen),
            MotivationCard(id: "4", text: "Тишина — это тоже ответ.", action: "Послушай тишину.", category: .zen),
            MotivationCard(id: "5", text: "Не бойся ошибаться.", action: "Сделай шаг в неизвестность.", category: .bold)
        ],
        "English": [
            MotivationCard(id: "1", text: "Your energy is your most valuable resource.", action: "Rest for 10 minutes without your phone.", category: .zen),
            MotivationCard(id: "2", text: "Do what you've been putting off.", action: "Start right now, even for 5 minutes.", category: .bold),
            MotivationCard(id: "3", text: "Smile at a stranger.", action: nil, category: .zen),
            MotivationCard(id: "4", text: "Silence is also an answer.", action: "Listen to the silence.", category: .zen),
            MotivationCard(id: "5", text: "Don't be afraid to make mistakes.", action: "Take a step into the unknown.", category: .bold)
        ],
        "Español": [
            MotivationCard(id: "1", text: "Tu energía es tu recurso más valioso.", action: "Descansa 10 minutos sin tu teléfono.", category: .zen),
            MotivationCard(id: "2", text: "Haz lo que has estado posponiendo.", action: "Empieza ahora mismo, aunque sea 5 minutos.", category: .bold),
            MotivationCard(id: "3", text: "Sonríe a un desconocido.", action: nil, category: .zen),
            MotivationCard(id: "4", text: "El silencio también es una respuesta.", action: "Escucha el silencio.", category: .zen),
            MotivationCard(id: "5", text: "No tengas miedo de cometer errores.", action: "Da un paso hacia lo desconocido.", category: .bold)
        ]
    ]
    
    func getCard(for date: Date, language: String = "Русский") -> MotivationCard {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        // Simple seed based on date
        let seed = day + month + year
        let localizedCards = cards[language] ?? cards["Русский"]!
        let index = seed % localizedCards.count
        
        return localizedCards[index]
    }
}
