import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Request notification permissions
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleNotifications()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Schedule daily notification at 6 AM
    func scheduleNotifications() {
        // Check if we already scheduled notifications today
        let lastScheduledDate = UserDefaults.standard.object(forKey: "lastNotificationScheduleDate") as? Date
        let calendar = Calendar.current
        if let lastDate = lastScheduledDate, calendar.isDateInToday(lastDate) {
            // Already scheduled today, skip
            return
        }
        
        // Remove all existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "VibeFlip"
        content.body = "Take a vibe ✨"
        content.sound = .default
        
        // DEBUG: Schedule every hour (change to 6 AM for production)
        var dateComponents = DateComponents()
        dateComponents.minute = 0  // Triggers at the start of every hour
        
        // Create repeating daily trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(identifier: "vibeflip_daily_notification", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("DEBUG: Scheduled hourly notification")
            }
        }
        
        // Save the date we scheduled notifications
        UserDefaults.standard.set(Date(), forKey: "lastNotificationScheduleDate")
    }
    
    /// Cancel all scheduled notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Check notification authorization status
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
}

