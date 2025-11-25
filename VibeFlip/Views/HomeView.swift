import SwiftUI

struct HomeView: View {
    @Binding var showSettings: Bool
    @Binding var showCalendar: Bool
    
    @State private var isCardOpen = false
    @State private var card: MotivationCard?
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Spacer()
                Button(action: {
                    HapticManager.shared.impact(style: .light)
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            // Main Content
            if isCardOpen, let card = card {
                CardView(card: card)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: {
                    openCard()
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Что там сегодня?")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.black)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            }
            
            Spacer()
            
            // Footer
            HStack {
                Button(action: {
                    HapticManager.shared.impact(style: .light)
                    showCalendar = true
                }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .onAppear {
            checkIfAlreadyOpened()
        }
    }
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"

    private func openCard() {
        HapticManager.shared.impact(style: .medium)
        let today = Date()
        card = DailyProvider.shared.getCard(for: today, language: selectedLanguage)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isCardOpen = true
        }
        
        HistoryManager.shared.markAsOpened(date: today)
    }
    
    private func checkIfAlreadyOpened() {
        let today = Date()
        if HistoryManager.shared.isOpened(date: today) {
            card = DailyProvider.shared.getCard(for: today, language: selectedLanguage)
            isCardOpen = true
        }
    }
}
