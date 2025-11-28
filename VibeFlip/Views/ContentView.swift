import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            HomeView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}
