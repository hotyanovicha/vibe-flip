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
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: widgetFamily == .systemSmall ? 8 : 16)
            
            // Quote text only
            Text(quote.text)
                .font(quoteFont)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .lineLimit(quoteLineLimit)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, widgetFamily == .systemSmall ? 12 : 20)
            
            // Action text for medium and large widget
            if (widgetFamily == .systemMedium || widgetFamily == .systemLarge), let action = quote.action {
                Spacer(minLength: widgetFamily == .systemMedium ? 12 : 16)
                
                if widgetFamily == .systemLarge {
                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(.primary.opacity(0.1))
                            .frame(width: 32, height: 1)
                        
                        Text(action)
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 24)
                    }
                } else {
                    // Medium widget - condensed action
                    Text(action)
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 16)
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
            return 6
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
    
    var body: some View {
        VStack(spacing: widgetFamily == .systemSmall ? 8 : 12) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: iconSize))
                .foregroundStyle(.green)
            
            Text("Quote revealed!")
                .font(.system(size: titleSize, weight: .medium))
                .foregroundStyle(.primary)
            
            Text("Open app to see it here")
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
                Text("Your daily vibe")
                    .font(.system(size: titleSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Tap to reveal")
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
