import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    // Keys for UserDefaults
    private let startHourKey = "notificationStartHour"
    private let startMinuteKey = "notificationStartMinute"
    private let endHourKey = "notificationEndHour"
    private let endMinuteKey = "notificationEndMinute"
    private let countKey = "notificationCount"
    private let enabledKey = "notificationsEnabled"
    
    private init() {
        // Set defaults if not already set
        registerDefaults()
    }
    
    private func registerDefaults() {
        let defaults: [String: Any] = [
            startHourKey: 9,
            startMinuteKey: 0,
            endHourKey: 22,
            endMinuteKey: 0,
            countKey: 5, // Default for ~3 hour interval (9:00 to 22:00 = 13 hours / 3 = ~4-5 notifications)
            enabledKey: false
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    // MARK: - Settings Access
    
    var startHour: Int {
        get { UserDefaults.standard.integer(forKey: startHourKey) }
        set { UserDefaults.standard.set(newValue, forKey: startHourKey) }
    }
    
    var startMinute: Int {
        get { UserDefaults.standard.integer(forKey: startMinuteKey) }
        set { UserDefaults.standard.set(newValue, forKey: startMinuteKey) }
    }
    
    var endHour: Int {
        get { UserDefaults.standard.integer(forKey: endHourKey) }
        set { UserDefaults.standard.set(newValue, forKey: endHourKey) }
    }
    
    var endMinute: Int {
        get { UserDefaults.standard.integer(forKey: endMinuteKey) }
        set { UserDefaults.standard.set(newValue, forKey: endMinuteKey) }
    }
    
    var notificationCount: Int {
        get { UserDefaults.standard.integer(forKey: countKey) }
        set { UserDefaults.standard.set(newValue, forKey: countKey) }
    }
    
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: enabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: enabledKey) }
    }
    
    // MARK: - Calculations
    
    /// Calculate total minutes between start and end time
    func totalMinutes() -> Int {
        let startTotalMinutes = startHour * 60 + startMinute
        var endTotalMinutes = endHour * 60 + endMinute
        
        // Handle midnight crossing
        if endTotalMinutes <= startTotalMinutes {
            endTotalMinutes += 24 * 60
        }
        
        return endTotalMinutes - startTotalMinutes
    }
    
    /// Calculate maximum notifications possible (minimum 30 min apart)
    func maxNotificationCount() -> Int {
        let minutes = totalMinutes()
        return max(1, (minutes / 30) + 1)
    }
    
    /// Calculate default notification count (~3 hour interval)
    func defaultNotificationCount() -> Int {
        let hours = totalMinutes() / 60
        return max(1, (hours / 3) + 1)
    }
    
    /// Calculate interval in minutes between notifications
    func intervalMinutes() -> Int {
        let count = notificationCount
        if count <= 1 {
            return totalMinutes()
        }
        return totalMinutes() / (count - 1)
    }
    
    // MARK: - Authorization
    
    /// Request notification permissions
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.isEnabled = true
                    self.scheduleNotifications()
                }
                completion?(granted)
            }
        }
    }
    
    /// Check notification authorization status
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // MARK: - Scheduling
    
    /// Schedule notifications based on current settings
    func scheduleNotifications() {
        // Remove all existing notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Check if notifications are enabled
        guard isEnabled else {
            return
        }
        
        let count = notificationCount
        let interval = intervalMinutes()
        let startTotalMinutes = startHour * 60 + startMinute
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "VibeFlip"
        content.body = "Take a vibe ✨"
        content.sound = .default
        
        for i in 0..<count {
            var notificationMinutes = startTotalMinutes + (i * interval)
            
            // Handle overflow past midnight
            if notificationMinutes >= 24 * 60 {
                notificationMinutes -= 24 * 60
            }
            
            let hour = notificationMinutes / 60
            let minute = notificationMinutes % 60
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "vibeflip_notification_\(i)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { _ in }
        }
    }
    
    /// Cancel all scheduled notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        isEnabled = false
    }
}
