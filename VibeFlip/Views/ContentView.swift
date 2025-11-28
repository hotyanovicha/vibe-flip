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

// Separate view for background to properly handle color scheme changes
struct BackgroundView: View {
    let cardStyle: CardStyle
    let colorScheme: ColorScheme
    
    private var isDark: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        switch cardStyle {
        case .classic:
            // Subtle gradient background for glass effect
            ZStack {
                Rectangle()
                    .fill(isDark ? Color.black : Color.white)
                
                // Soft ambient gradient
                LinearGradient(
                    colors: isDark
                        ? [Color.purple.opacity(0.15), Color.blue.opacity(0.1)]
                        : [Color.purple.opacity(0.08), Color.blue.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Subtle accent
                RadialGradient(
                    colors: isDark
                        ? [Color.pink.opacity(0.1), Color.clear]
                        : [Color.pink.opacity(0.06), Color.clear],
                    center: .bottomTrailing,
                    startRadius: 100,
                    endRadius: 400
                )
            }
            
        case .gradient:
            // Vibrant gradient background
            ZStack {
                // Base rich gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.3, green: 0.2, blue: 0.8),
                        Color(red: 0.6, green: 0.2, blue: 0.7),
                        Color(red: 0.8, green: 0.3, blue: 0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Floating orb top-right
                RadialGradient(
                    colors: [
                        Color.cyan.opacity(0.4),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.9, y: 0.1),
                    startRadius: 20,
                    endRadius: 200
                )
                
                // Floating orb bottom-left
                RadialGradient(
                    colors: [
                        Color.orange.opacity(0.3),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.1, y: 0.85),
                    startRadius: 30,
                    endRadius: 250
                )
                
                // Center glow
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.15),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: 400
                )
            }
        }
    }
}
