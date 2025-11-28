import SwiftUI

@main
struct VibeFlipApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        // Request notification permissions and schedule notifications on app launch
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
}
