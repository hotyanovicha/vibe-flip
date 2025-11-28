import SwiftUI

struct CardView: View {
    let card: MotivationCard
    
    @State private var offset = CGSize.zero
    @State private var isRippling = false
    @State private var rippleScale: CGFloat = 1.0
    @State private var rippleOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // Ripple Effect Layers
            if isRippling {
                ForEach(0..<3) { i in
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        .scaleEffect(rippleScale)
                        .opacity(rippleOpacity)
                        .animation(
                            Animation.easeOut(duration: 1.5)
                                .delay(Double(i) * 0.2)
                                .repeatForever(autoreverses: false),
                            value: rippleScale
                        )
                }
            }
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(card.text)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                if let action = card.action {
                    VStack(spacing: 8) {
                        Text("CHALLENGE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        Text(action)
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding(40)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.primary.opacity(0.1), radius: 20, x: 0, y: 10)
            .rotation3DEffect(
                .degrees(Double(offset.width / 10)),
                axis: (x: 0, y: 1, z: 0)
            )
            .rotation3DEffect(
                .degrees(Double(-offset.height / 10)),
                axis: (x: 1, y: 0, z: 0)
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        HapticManager.shared.impact(style: .soft)
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        withAnimation {
                            isRippling = true
                            rippleScale = 2.5
                            rippleOpacity = 0.0
                        }
                        
                        // Reset animation after it completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isRippling = false
                            rippleScale = 1.0
                            rippleOpacity = 1.0
                        }
                    }
            )
        }
        .padding(20)
    }
}
