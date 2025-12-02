//
//  WidgetViews.swift
//  VibeFlipWidget
//
//  Created by Alex Hotyanovich on 12/1/25.
//

import SwiftUI
import WidgetKit

// MARK: - Quote Revealed View (with quote text)

struct QuoteRevealedView: View {
    let quote: WidgetQuoteData
    let widgetFamily: WidgetFamily
    
    private var selectedLanguage: String {
        WidgetDataProvider.getSelectedLanguage()
    }
    
    private var challengeText: String {
        WidgetLocalizedStrings.getText("challenge", language: selectedLanguage)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: widgetFamily == .systemSmall ? 8 : 16)
            
            // Quote text
            Text(quote.text)
                .font(quoteFont)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .lineLimit(quoteLineLimit)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, widgetFamily == .systemSmall ? 12 : 20)
            
            // Action text for ALL widget sizes
            if let action = quote.action {
                Spacer(minLength: widgetFamily == .systemSmall ? 8 : (widgetFamily == .systemMedium ? 12 : 16))
                
                if widgetFamily == .systemLarge {
                    // Large widget - full action with divider and label
                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(.primary.opacity(0.1))
                            .frame(width: 32, height: 1)
                        
                        Text(challengeText)
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(1.5)
                            .foregroundStyle(.tertiary)
                        
                        Text(action)
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 24)
                    }
                } else if widgetFamily == .systemMedium {
                    // Medium widget - condensed action with label
                    VStack(spacing: 6) {
                        Text(challengeText)
                            .font(.system(size: 9, weight: .semibold))
                            .tracking(1.0)
                            .foregroundStyle(.tertiary)
                        
                        Text(action)
                            .font(.system(size: 12, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 16)
                    }
                } else {
                    // Small widget - compact action with label
                    VStack(spacing: 4) {
                        Text(challengeText)
                            .font(.system(size: 8, weight: .semibold))
                            .tracking(0.5)
                            .foregroundStyle(.tertiary)
                        
                        Text(action)
                            .font(.system(size: 10, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                            .padding(.horizontal, 12)
                    }
                }
            }
            
            Spacer(minLength: widgetFamily == .systemSmall ? 8 : 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "vibeflip://home"))
    }
    
    private var quoteLineLimit: Int {
        switch widgetFamily {
        case .systemSmall:
            return quote.action != nil ? 4 : 6 // Less lines if action present
        case .systemMedium:
            return 3
        case .systemLarge:
            return 10
        default:
            return 5
        }
    }
    
    private var quoteFont: Font {
        switch widgetFamily {
        case .systemSmall:
            return .system(size: 14, design: .default)
        case .systemMedium:
            return .system(size: 16, design: .default)
        case .systemLarge:
            return .system(size: 22, design: .default)
        default:
            return .system(size: 15, design: .default)
        }
    }
}

// MARK: - Quote Revealed but No Data View (widget added after reveal)

struct QuoteRevealedNoDataView: View {
    let widgetFamily: WidgetFamily
    
    private var selectedLanguage: String {
        WidgetDataProvider.getSelectedLanguage()
    }
    
    var body: some View {
        VStack(spacing: widgetFamily == .systemSmall ? 8 : 12) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: iconSize))
                .foregroundStyle(.green)
            
            Text(WidgetLocalizedStrings.getText("quote_revealed", language: selectedLanguage))
                .font(.system(size: titleSize, weight: .medium))
                .foregroundStyle(.primary)
            
            Text(WidgetLocalizedStrings.getText("open_app_to_see", language: selectedLanguage))
                .font(.system(size: subtitleSize))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "vibeflip://home"))
    }
    
    private var iconSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 24
        case .systemLarge: return 36
        default: return 28
        }
    }
    
    private var titleSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 14
        case .systemLarge: return 18
        default: return 15
        }
    }
    
    private var subtitleSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 10
        case .systemLarge: return 14
        default: return 12
        }
    }
}

// MARK: - Quote Not Revealed View

struct QuoteNotRevealedView: View {
    let widgetFamily: WidgetFamily
    
    private var selectedLanguage: String {
        WidgetDataProvider.getSelectedLanguage()
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            Spacer()
            
            // Sparkle icon
            Image(systemName: "sparkles")
                .font(.system(size: iconSize))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Call to action text
            VStack(spacing: 4) {
                Text(WidgetLocalizedStrings.getText("your_daily_vibe", language: selectedLanguage))
                    .font(.system(size: titleSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(WidgetLocalizedStrings.getText("tap_to_reveal", language: selectedLanguage))
                    .font(.system(size: subtitleSize))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "vibeflip://reveal"))
    }
    
    private var spacing: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 8
        case .systemLarge: return 16
        default: return 10
        }
    }
    
    private var iconSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 24
        case .systemLarge: return 40
        default: return 30
        }
    }
    
    private var titleSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 14
        case .systemLarge: return 18
        default: return 15
        }
    }
    
    private var subtitleSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 11
        case .systemLarge: return 14
        default: return 12
        }
    }
}
