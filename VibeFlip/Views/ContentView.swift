import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    @State private var showCalendar = false
    
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            HomeView(showSettings: $showSettings, showCalendar: $showCalendar)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showCalendar) {
            CalendarView()
        }
    }
}
