import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    @AppStorage("selectedCardStyle") private var selectedCardStyle = CardStyle.classic.rawValue
    @Environment(\.colorScheme) var systemColorScheme
    
    private var currentTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }
    
    private var currentCardStyle: CardStyle {
        CardStyle(rawValue: selectedCardStyle) ?? .classic
    }
    
    // Compute effective color scheme based on user selection
    private var effectiveColorScheme: ColorScheme {
        switch currentTheme {
        case .system:
            return systemColorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var body: some View {
        ZStack {
            // Adaptive Background based on card style
            BackgroundView(cardStyle: currentCardStyle, colorScheme: effectiveColorScheme)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: effectiveColorScheme)
                .animation(.easeInOut(duration: 0.3), value: currentCardStyle)
            
            HomeView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .preferredColorScheme(currentTheme.colorScheme)
    }
}

// MARK: - Animated Material Background
struct BackgroundView: View {
    let cardStyle: CardStyle
    let colorScheme: ColorScheme
    
    @State private var animateOrbs = false
    
    private var isDark: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        switch cardStyle {
        case .classic:
            // Apple Materials style: vibrant animated background
            TimelineView(.animation(minimumInterval: 1/30)) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    
                    // Base color
                    context.fill(
                        Path(CGRect(origin: .zero, size: size)),
                        with: .color(isDark ? Color(white: 0.08) : Color(white: 0.96))
                    )
                    
                    // Animated orbs
                    let orbs: [(Color, CGFloat, CGFloat, CGFloat, Double)] = [
                        // (color, baseX, baseY, radius, speed)
                        (Color.purple, 0.2, 0.3, 300, 0.3),
                        (Color.blue, 0.8, 0.2, 250, 0.4),
                        (Color.pink, 0.7, 0.8, 280, 0.35),
                        (Color.cyan, 0.3, 0.7, 220, 0.45),
                        (Color.indigo, 0.5, 0.5, 350, 0.25),
                    ]
                    
                    for (color, baseX, baseY, radius, speed) in orbs {
                        let offsetX = sin(time * speed) * 50
                        let offsetY = cos(time * speed * 0.8) * 40
                        
                        let centerX = size.width * baseX + offsetX
                        let centerY = size.height * baseY + offsetY
                        
                        let gradient = Gradient(colors: [
                            color.opacity(isDark ? 0.4 : 0.3),
                            color.opacity(0)
                        ])
                        
                        context.fill(
                            Circle().path(in: CGRect(
                                x: centerX - radius,
                                y: centerY - radius,
                                width: radius * 2,
                                height: radius * 2
                            )),
                            with: .radialGradient(
                                gradient,
                                center: CGPoint(x: centerX, y: centerY),
                                startRadius: 0,
                                endRadius: radius
                            )
                        )
                    }
                }
            }
            
        case .gradient:
            // Vibrant gradient background with animated orbs
            ZStack {
                // Base rich gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.1, blue: 0.35),
                        Color(red: 0.25, green: 0.1, blue: 0.4),
                        Color(red: 0.35, green: 0.15, blue: 0.35)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated floating orbs
                GeometryReader { geo in
                    ZStack {
                        // Cyan orb - top right
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.cyan.opacity(0.6), Color.cyan.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 150
                                )
                            )
                            .frame(width: 300, height: 300)
                            .offset(
                                x: geo.size.width * 0.3 + (animateOrbs ? 20 : -20),
                                y: -geo.size.height * 0.2 + (animateOrbs ? -15 : 15)
                            )
                        
                        // Orange orb - bottom left
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.orange.opacity(0.5), Color.orange.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 180
                                )
                            )
                            .frame(width: 360, height: 360)
                            .offset(
                                x: -geo.size.width * 0.3 + (animateOrbs ? -25 : 25),
                                y: geo.size.height * 0.35 + (animateOrbs ? 20 : -20)
                            )
                        
                        // Purple orb - center
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.purple.opacity(0.4), Color.purple.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 200
                                )
                            )
                            .frame(width: 400, height: 400)
                            .offset(
                                x: animateOrbs ? 30 : -30,
                                y: animateOrbs ? -20 : 20
                            )
                        
                        // Pink orb - top left
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.pink.opacity(0.45), Color.pink.opacity(0)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 240, height: 240)
                            .offset(
                                x: -geo.size.width * 0.25 + (animateOrbs ? 15 : -15),
                                y: -geo.size.height * 0.3 + (animateOrbs ? -10 : 10)
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .blur(radius: 60)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animateOrbs = true
                }
            }
        }
    }
}
