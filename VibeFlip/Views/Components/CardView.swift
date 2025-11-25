import SwiftUI

struct CardView: View {
    let card: MotivationCard
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(card.text)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                if let action = card.action {
                    VStack(spacing: 8) {
                        Text("CHALLENGE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text(action)
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
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
        }
        .padding(20)
    }
}
