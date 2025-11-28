import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    @AppStorage("selectedTheme") private var selectedTheme = AppTheme.system.rawValue
    
    private var currentTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            HomeView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .preferredColorScheme(currentTheme.colorScheme)
    }
}
