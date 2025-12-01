import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    func localizedName(language: String) -> String {
        switch self {
        case .system:
            return LocalizedStrings.getText("theme_system", language: language)
        case .light:
            return LocalizedStrings.getText("theme_light", language: language)
        case .dark:
            return LocalizedStrings.getText("theme_dark", language: language)
        }
    }
}

