import SwiftUI

struct CardView: View {
    let card: MotivationCard
    var style: CardStyle = .classic
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @Environment(\.colorScheme) var colorScheme
    
    // State for animations
    @State private var offset = CGSize.zero
    
    var body: some View {
        // Main Card Content
        VStack(spacing: 20) {
                // Icon
                HStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(textColor.opacity(0.6))
                }
                
                Spacer()
                
                // Motivation Text
                Text(card.text)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(textColor)
                    .padding(.horizontal, 10)
                    // Subtle glow in dark mode for readability
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.1) : .clear, radius: 5)
                
                // Challenge Section
                if let action = card.action {
                    VStack(spacing: 12) {
                        Text(LocalizedStrings.getText("challenge", language: selectedLanguage).uppercased())
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(2.5)
                            .foregroundColor(textColor.opacity(0.5))
                        
                        Text(action)
                            .font(.callout)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(textColor.opacity(0.8))
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(40)
            .background(backgroundView)
            .contentShape(Rectangle()) // Makes entire card area touchable
            .clipShape(RoundedRectangle(cornerRadius: 32))
            // Glass shadow
            .shadow(
                color: shadowColor,
                radius: 25,
                x: 0,
                y: 12
            )
            // 3D rotation effect
            .rotation3DEffect(
                .degrees(Double(offset.width / 15)),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.8
            )
            .rotation3DEffect(
                .degrees(Double(-offset.height / 15)),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.8
            )
            .gesture(dragGesture)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(card.action != nil ? "\(card.text). \(LocalizedStrings.getText("challenge", language: selectedLanguage)): \(card.action!)" : card.text)
            .padding(20)
    }
    
    // MARK: - Subviews & Computed Properties
    
    // Glass card background (solid color - no touch color change)
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 32)
            .fill(
                colorScheme == .dark
                    ? Color(red: 0.12, green: 0.12, blue: 0.14)
                    : Color(red: 0.96, green: 0.96, blue: 0.98)
            )
            .overlay(
                // Glass edge highlight
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5),
                                Color.white.opacity(0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
    
    // Adaptive text color based on background
    var textColor: Color {
        switch style {
        case .classic:
            return .primary // Automatically black in light, white in dark
        case .gradient:
            return .white // White text on colorful background
        }
    }
    
    // Adaptive shadow color
    var shadowColor: Color {
        return Color.black.opacity(colorScheme == .dark ? 0.4 : 0.2)
    }
    
    // Drag gesture for 3D effect
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.interactiveSpring()) {
                    offset = gesture.translation
                }
                HapticManager.shared.impact(style: .soft)
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    offset = .zero
                }
            }
    }
}
