import SwiftUI

struct CardView: View {
    let card: MotivationCard
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @Environment(\.colorScheme) var colorScheme
    
    // State for animations
    @State private var offset = CGSize.zero
    @State private var isPressed = false
    @State private var dragScale: CGFloat = 1.0
    
    var body: some View {
        // Main Card Content - Apple Liquid Glass Style
        VStack(spacing: 24) {
            // Subtle top accent line - Liquid Glass refraction effect
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.0),
                            Color.white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                            Color.white.opacity(0.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 60, height: 4)
                .blur(radius: 1)
            
            Spacer()
            
            // Motivation Text - SF Pro Display style
            Text(card.text)
                .font(.system(size: 26, weight: .semibold, design: .default))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
            
            // Challenge Section
            if let action = card.action {
                VStack(spacing: 14) {
                    // Divider line
                    Rectangle()
                        .fill(.primary.opacity(0.1))
                        .frame(width: 40, height: 1)
                    
                    Text(LocalizedStrings.getText("challenge", language: selectedLanguage).uppercased())
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(.secondary)
                    
                    Text(action)
                        .font(.system(size: 15, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding(36)
        .background(liquidGlassBackground)
        .contentShape(RoundedRectangle(cornerRadius: 36))
        .clipShape(RoundedRectangle(cornerRadius: 36))
        // Liquid Glass shadow - soft and diffused
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.12), radius: 30, x: 0, y: 15)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.06), radius: 10, x: 0, y: 5)
        // Fixed aspect ratio - wider and shorter card
        .aspectRatio(0.75, contentMode: .fit) // 3:4 ratio (width:height)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        // Smooth offset
        .offset(x: offset.width * 0.25, y: offset.height * 0.25)
        // Subtle rotation
        .rotationEffect(.degrees(Double(offset.width / 30)))
        // Scale effects
        .scaleEffect(isPressed ? 0.97 : dragScale)
        .gesture(dragGesture)
        .simultaneousGesture(pressGesture)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(card.action != nil ? "\(card.text). \(LocalizedStrings.getText("challenge", language: selectedLanguage)): \(card.action!)" : card.text)
        .onAppear {
            HapticManager.shared.notification(type: .success)
        }
    }
    
    // MARK: - Apple Liquid Glass Background
    
    @ViewBuilder
    var liquidGlassBackground: some View {
        ZStack {
            // Base material layer - true Liquid Glass
            RoundedRectangle(cornerRadius: 36)
                .fill(.ultraThinMaterial)
            
            // Inner glow / refraction effect
            RoundedRectangle(cornerRadius: 36)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.08 : 0.15),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 400
                    )
                )
            
            // Edge highlight - top and left (light source simulation)
            RoundedRectangle(cornerRadius: 36)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.25 : 0.6),
                            Color.white.opacity(colorScheme == .dark ? 0.08 : 0.2),
                            Color.white.opacity(0.02),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            
            // Inner stroke for depth
            RoundedRectangle(cornerRadius: 35)
                .stroke(
                    Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05),
                    lineWidth: 0.5
                )
                .padding(1)
        }
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
                HapticManager.shared.impact(style: .light)
            }
    }
}
