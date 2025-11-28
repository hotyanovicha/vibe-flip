import SwiftUI

struct CardView: View {
    let card: MotivationCard
    var style: CardStyle = .classic
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @Environment(\.colorScheme) var colorScheme
    
    // State for animations
    @State private var offset = CGSize.zero
    @State private var isPressed = false
    @State private var showSparkles = false
    @State private var dragScale: CGFloat = 1.0
    
    var body: some View {
        // Main Card Content
        VStack(spacing: 20) {
            // Icon with SF Symbol Effect
            HStack {
                Spacer()
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.wiggle, options: .repeating, value: showSparkles)
            }
            
            Spacer()
            
            // Motivation Text
            Text(card.text)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(textColor)
                .padding(.horizontal, 10)
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
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 32))
        // Glass shadow
        .shadow(
            color: shadowColor,
            radius: isPressed ? 15 : 25,
            x: 0,
            y: isPressed ? 6 : 12
        )
        // 2D offset instead of 3D rotation (fixes material transparency bug)
        .offset(x: offset.width * 0.3, y: offset.height * 0.3)
        // Soft tilt effect (2D rotation)
        .rotationEffect(.degrees(Double(offset.width / 25)))
        // Scale effects: drag scale + press scale
        .scaleEffect(isPressed ? 0.95 : dragScale)
        // Press state dimming
        .brightness(isPressed ? -0.02 : 0)
        .gesture(dragGesture)
        .simultaneousGesture(pressGesture)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(card.action != nil ? "\(card.text). \(LocalizedStrings.getText("challenge", language: selectedLanguage)): \(card.action!)" : card.text)
        .padding(20)
        .onAppear {
            // Trigger sparkle animation on appear
            HapticManager.shared.notification(type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showSparkles = true
            }
        }
    }
    
    // MARK: - Subviews & Computed Properties
    
    // Apple Materials style glass background
    @ViewBuilder
    var backgroundView: some View {
        switch style {
        case .classic:
            // Use SwiftUI Material for true frosted glass effect
            RoundedRectangle(cornerRadius: 32)
                .fill(.thickMaterial)
                .overlay(
                    // Glass edge highlight
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
        case .gradient:
            // Vibrant gradient style with material overlay
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.15),
                                    Color.pink.opacity(0.1),
                                    Color.orange.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    // Glass edge highlight
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
        }
    }
    
    // Adaptive text color - works with vibrancy in materials
    var textColor: Color {
        .primary // Automatically adapts to material background
    }
    
    // Adaptive shadow for depth
    var shadowColor: Color {
        Color.black.opacity(colorScheme == .dark ? 0.5 : 0.25)
    }
    
    // MARK: - Gestures
    
    // Drag gesture for 2D wiggle effect
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.6)) {
                    offset = gesture.translation
                    // Subtle scale down when dragging far
                    let distance = sqrt(pow(gesture.translation.width, 2) + pow(gesture.translation.height, 2))
                    dragScale = max(0.95, 1 - distance / 1000)
                }
            }
            .onEnded { _ in
                // Jelly bounce back
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                    offset = .zero
                    dragScale = 1.0
                }
                HapticManager.shared.impact(style: .soft)
            }
    }
    
    // Press gesture for jelly effect
    var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !isPressed {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                        isPressed = true
                    }
                    HapticManager.shared.impact(style: .light)
                }
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                    isPressed = false
                }
                // Toggle sparkle animation on tap
                showSparkles.toggle()
                HapticManager.shared.impact(style: .light)
            }
    }
}
