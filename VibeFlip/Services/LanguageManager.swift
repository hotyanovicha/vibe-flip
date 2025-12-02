//
//  LanguageManager.swift
//  VibeFlip
//
//  Manages language settings and syncs between app and widget
//

import Foundation
import Combine
import WidgetKit

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    // App Group identifier for sharing data with widget
    static let appGroupIdentifier = "group.com.vibeflip.shared"
    
    // Keys for UserDefaults
    private let selectedLanguageKey = "selectedLanguage"
    private let hasInitializedLanguageKey = "hasInitializedLanguage"
    
    // Available languages
    static let supportedLanguages = ["English", "Русский", "Español"]
    
    // Published property for SwiftUI reactivity
    @Published private(set) var currentLanguage: String = "English"
    
    // Mapping of system language codes to app language names
    private let languageCodeMapping: [String: String] = [
        "en": "English",
        "ru": "Русский",
        "es": "Español"
    ]
    
    private var sharedDefaults: UserDefaults? {
        #if targetEnvironment(simulator)
        return UserDefaults.standard
        #else
        return UserDefaults(suiteName: LanguageManager.appGroupIdentifier)
        #endif
    }
    
    private init() {
        initializeLanguageIfNeeded()
        // Load current language after initialization
        currentLanguage = sharedDefaults?.string(forKey: selectedLanguageKey) ?? "English"
    }
    
    /// Set the language and sync with widget
    func setLanguage(_ language: String) {
        guard LanguageManager.supportedLanguages.contains(language) else {
            print("⚠️ VibeFlip: Unsupported language: \(language)")
            return
        }
        
        // Update published property
        currentLanguage = language
        
        // Save to shared defaults for widget access
        sharedDefaults?.set(language, forKey: selectedLanguageKey)
        sharedDefaults?.synchronize()
        
        // Also save to standard UserDefaults for @AppStorage compatibility
        UserDefaults.standard.set(language, forKey: selectedLanguageKey)
        
        print("✅ VibeFlip: Language set to \(language)")
        
        // Reload widget timelines to update language
        reloadWidgets()
    }
    
    /// Reload all widget timelines
    func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
        print("🔄 VibeFlip: Widget timelines reloaded")
    }
    
    /// Detect system language and return matching app language
    func detectSystemLanguage() -> String {
        // Get the preferred language from the system
        let preferredLanguages = Locale.preferredLanguages
        
        for preferredLanguage in preferredLanguages {
            // Extract the language code (e.g., "en-US" -> "en")
            let languageCode = String(preferredLanguage.prefix(2))
            
            if let mappedLanguage = languageCodeMapping[languageCode] {
                return mappedLanguage
            }
        }
        
        // Default to English if no match found
        return "English"
    }
    
    // MARK: - Private Methods
    
    /// Initialize language on first launch based on system language
    private func initializeLanguageIfNeeded() {
        // Check if we've already initialized the language
        let hasInitialized = sharedDefaults?.bool(forKey: hasInitializedLanguageKey) ?? false
        
        if !hasInitialized {
            // First launch - detect system language
            let systemLanguage = detectSystemLanguage()
            
            // Set the detected language
            sharedDefaults?.set(systemLanguage, forKey: selectedLanguageKey)
            sharedDefaults?.set(true, forKey: hasInitializedLanguageKey)
            sharedDefaults?.synchronize()
            
            // Also update standard UserDefaults
            UserDefaults.standard.set(systemLanguage, forKey: selectedLanguageKey)
            
            // Update published property
            currentLanguage = systemLanguage
            
            print("🌐 VibeFlip: First launch - Language auto-detected as \(systemLanguage)")
        } else {
            // Migrate existing language setting to shared defaults if needed
            migrateLanguageToSharedDefaults()
        }
    }
    
    /// Migrate language from standard UserDefaults to shared defaults
    private func migrateLanguageToSharedDefaults() {
        // If shared defaults doesn't have language but standard does, migrate it
        if sharedDefaults?.string(forKey: selectedLanguageKey) == nil,
           let standardLanguage = UserDefaults.standard.string(forKey: selectedLanguageKey) {
            sharedDefaults?.set(standardLanguage, forKey: selectedLanguageKey)
            sharedDefaults?.synchronize()
            print("📦 VibeFlip: Migrated language setting to App Group")
        }
    }
}

// MARK: - Widget Extension Helper

/// Static helper for widget to access language setting
struct WidgetLanguageProvider {
    static let appGroupIdentifier = "group.com.vibeflip.shared"
    private static let selectedLanguageKey = "selectedLanguage"
    
    private static var sharedDefaults: UserDefaults? {
        #if targetEnvironment(simulator)
        return UserDefaults.standard
        #else
        return UserDefaults(suiteName: appGroupIdentifier)
        #endif
    }
    
    /// Get the currently selected language for widget use
    static func getCurrentLanguage() -> String {
        return sharedDefaults?.string(forKey: selectedLanguageKey) ?? detectSystemLanguage()
    }
    
    /// Detect system language (fallback for widget)
    private static func detectSystemLanguage() -> String {
        let preferredLanguages = Locale.preferredLanguages
        let languageCodeMapping: [String: String] = [
            "en": "English",
            "ru": "Русский",
            "es": "Español"
        ]
        
        for preferredLanguage in preferredLanguages {
            let languageCode = String(preferredLanguage.prefix(2))
            if let mappedLanguage = languageCodeMapping[languageCode] {
                return mappedLanguage
            }
        }
        
        return "English"
    }
}
