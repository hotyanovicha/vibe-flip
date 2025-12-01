import SwiftUI

@main
struct VibeFlipApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var shouldAutoReveal = false
    
    init() {
        // Request notification permissions and schedule notifications on app launch
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(shouldAutoReveal: $shouldAutoReveal)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // Reschedule notifications when app becomes active
            if newPhase == .active {
                NotificationManager.shared.checkAuthorizationStatus { authorized in
                    if authorized {
                        NotificationManager.shared.scheduleNotifications()
                    }
                }
            }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "vibeflip" else { return }
        
        switch url.host {
        case "reveal":
            // Widget tapped when quote not revealed - auto-reveal the card
            shouldAutoReveal = true
        case "home":
            // Widget tapped when quote is revealed - just open app (no action needed)
            break
        default:
            break
        }
    }
}
