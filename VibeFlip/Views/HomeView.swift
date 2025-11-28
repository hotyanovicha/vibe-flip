import SwiftUI

struct HomeView: View {
    @Binding var showSettings: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    @State private var isCardOpen = false
    @State private var card: MotivationCard?
    @AppStorage("selectedCardStyle") private var selectedCardStyle = CardStyle.classic.rawValue
    
    private var currentCardStyle: CardStyle {
        CardStyle(rawValue: selectedCardStyle) ?? .classic
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Spacer()
                Button(action: {
                    HapticManager.shared.impact(style: .light)
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .padding(14)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                }
                .accessibilityLabel(LocalizedStrings.getText("settings_accessibility", language: selectedLanguage))
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            // Main Content
            if isCardOpen, let card = card {
                CardView(card: card, style: currentCardStyle)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: {
                    openCard()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .symbolRenderingMode(.hierarchical)
                        Text(LocalizedStrings.getText("give_me_vibe", language: selectedLanguage))
                            .fontWeight(.semibold)
                    }
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.vertical, 18)
                    .padding(.horizontal, 36)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .shadow(color: .purple.opacity(0.2), radius: 20, x: 0, y: 8)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .accessibilityHint(LocalizedStrings.getText("card_accessibility_hint", language: selectedLanguage))
            }
            
            Spacer()
            
            // Footer
            Spacer()
                .frame(height: 20)
        }
        .onChange(of: selectedLanguage) {
            isCardOpen = false
            card = nil
        }
    }
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"

    private func openCard() {
        HapticManager.shared.impact(style: .medium)
        let today = Date()
        card = DailyProvider.shared.getCard(for: today, language: selectedLanguage)
        
        if reduceMotion {
            isCardOpen = true
        } else {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isCardOpen = true
            }
        }
    }
    
    private func checkIfAlreadyOpened() {
        let today = Date()
        if HistoryManager.shared.isOpened(date: today) {
            card = DailyProvider.shared.getCard(for: today, language: selectedLanguage)
            isCardOpen = true
        }
    }
}
