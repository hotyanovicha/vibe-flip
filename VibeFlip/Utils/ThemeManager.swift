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

// MARK: - Card Visual Styles

enum CardStyle: String, CaseIterable {
    case classic   // Clean minimalist (like the original)
    case gradient  // Vibrant gradient look
    
    func localizedName(language: String) -> String {
        switch self {
        case .classic:
            return LocalizedStrings.getText("card_style_classic", language: language)
        case .gradient:
            return LocalizedStrings.getText("card_style_gradient", language: language)
        }
    }
    
    var iconName: String {
        switch self {
        case .classic:
            return "square"
        case .gradient:
            return "square.fill.on.square.fill"
        }
    }
}

