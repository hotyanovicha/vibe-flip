import SwiftUI

struct ContentView: View {
    @Binding var shouldAutoReveal: Bool
    @State private var showSettings = false
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    @Environment(\.colorScheme) var systemColorScheme
    
    private var currentTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
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
            // Liquid Glass style background
            BackgroundView(colorScheme: effectiveColorScheme)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: effectiveColorScheme)
            
            HomeView(showSettings: $showSettings, shouldAutoReveal: $shouldAutoReveal)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .preferredColorScheme(currentTheme.colorScheme)
    }
}

// MARK: - Apple Liquid Glass Background
struct BackgroundView: View {
    let colorScheme: ColorScheme
    
    private var isDark: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        // Liquid Glass style: subtle animated gradient background
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                // Base color - clean and minimal
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(isDark ? Color(white: 0.06) : Color(white: 0.98))
                )
                
                // Subtle animated orbs - Apple style soft colors
                let orbs: [(Color, CGFloat, CGFloat, CGFloat, Double)] = [
                    // (color, baseX, baseY, radius, speed)
                    (Color.blue, 0.25, 0.25, 350, 0.2),
                    (Color.purple, 0.75, 0.3, 300, 0.25),
                    (Color.cyan, 0.6, 0.75, 320, 0.22),
                    (Color.indigo, 0.35, 0.65, 280, 0.18),
                ]
                
                for (color, baseX, baseY, radius, speed) in orbs {
                    let offsetX = sin(time * speed) * 40
                    let offsetY = cos(time * speed * 0.7) * 30
                    
                    let centerX = size.width * baseX + offsetX
                    let centerY = size.height * baseY + offsetY
                    
                    let gradient = Gradient(colors: [
                        color.opacity(isDark ? 0.25 : 0.18),
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
    }
}
