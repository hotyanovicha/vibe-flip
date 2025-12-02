import SwiftUI
import WidgetKit

struct HomeView: View {
    @Binding var showSettings: Bool
    @Binding var shouldAutoReveal: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    @State private var isCardOpen = false
    @State private var currentCard: MotivationCard?
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    // Sync language on view appear
    private func syncLanguageFromManager() {
        let managerLanguage = LanguageManager.shared.currentLanguage
        if selectedLanguage != managerLanguage {
            selectedLanguage = managerLanguage
        }
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                // Back button (visible when card is open)
                Button(action: {
                    closeCard()
                }) {
                    Image(systemName: "chevron.left")
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
                .opacity(isCardOpen ? 1 : 0)
                .disabled(!isCardOpen)
                .accessibilityLabel("Back")
                
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
            if isCardOpen, let card = currentCard {
                CardView(card: card)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: {
                    openCard()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18, weight: .medium))
                        Text(LocalizedStrings.getText("give_me_vibe", language: selectedLanguage))
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundStyle(.primary)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .accessibilityHint(LocalizedStrings.getText("card_accessibility_hint", language: selectedLanguage))
            }
            
            Spacer()
            
            // Footer
            Spacer()
                .frame(height: 20)
        }
        .onChange(of: selectedLanguage) { oldValue, newValue in
            isCardOpen = false
            currentCard = nil
            
            // Ensure LanguageManager is synced (in case language changed outside settings)
            if LanguageManager.shared.currentLanguage != newValue {
                LanguageManager.shared.setLanguage(newValue)
            }
        }
        .onChange(of: shouldAutoReveal) { _, newValue in
            if newValue && !isCardOpen {
                // Auto-reveal card from widget deep link
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    openCard()
                    shouldAutoReveal = false
                }
            }
        }
        .onAppear {
            // Sync language from LanguageManager (in case it was auto-detected)
            syncLanguageFromManager()
            
            // Handle case where app is launched fresh via deep link
            if shouldAutoReveal && !isCardOpen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    openCard()
                    shouldAutoReveal = false
                }
            }
        }
    }

    private func openCard() {
        HapticManager.shared.impact(style: .medium)
        SoundManager.shared.playCardReveal()
        
        let today = Date()
        let card = DailyProvider.shared.getCard(for: today, language: selectedLanguage)
        currentCard = card
        
        // Save quote for widget
        HistoryManager.shared.saveQuoteForWidget(text: card.text, action: card.action, date: today)
        
        if reduceMotion {
            isCardOpen = true
        } else {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isCardOpen = true
            }
        }
    }
    
    private func closeCard() {
        HapticManager.shared.impact(style: .light)
        
        if reduceMotion {
            isCardOpen = false
            currentCard = nil
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isCardOpen = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentCard = nil
            }
        }
    }
}
