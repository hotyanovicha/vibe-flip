import SwiftUI
import WidgetKit

@main
struct VibeFlipApp: App {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var shouldAutoReveal = false
    
    init() {
        // Request notification permissions and schedule notifications on app launch
        NotificationManager.shared.requestAuthorization()
        // Sync language to shared defaults on app launch
        syncLanguageToSharedDefaults()
    }
    
    private func syncLanguageToSharedDefaults() {
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
        #if targetEnvironment(simulator)
        // In simulator, both use standard defaults
        #else
        if let sharedDefaults = UserDefaults(suiteName: HistoryManager.appGroupIdentifier) {
            sharedDefaults.set(language, forKey: "selectedLanguage")
            sharedDefaults.synchronize()
        }
        #endif
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
