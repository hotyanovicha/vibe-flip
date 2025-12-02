//
//  VibeFlipWidget.swift
//  VibeFlipWidget
//
//  Created by Alex Hotyanovich on 12/1/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        let language = WidgetDataProvider.getCurrentLanguage()
        let placeholderText = WidgetStrings.getText("widget_daily_vibe", language: language)
        return QuoteEntry(date: Date(), quote: WidgetQuoteData(text: placeholderText, action: nil), isRevealed: true, language: language)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let entry: QuoteEntry
        let isRevealed = WidgetDataProvider.isTodayQuoteRevealed()
        let language = WidgetDataProvider.getCurrentLanguage()
        
        if let quote = WidgetDataProvider.getTodayQuote() {
            entry = QuoteEntry(date: Date(), quote: quote, isRevealed: true, language: language)
        } else {
            entry = QuoteEntry(date: Date(), quote: nil, isRevealed: isRevealed, language: language)
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let currentDate = Date()
        let isRevealed = WidgetDataProvider.isTodayQuoteRevealed()
        let language = WidgetDataProvider.getCurrentLanguage()
        
        let entry: QuoteEntry
        if let quote = WidgetDataProvider.getTodayQuote() {
            entry = QuoteEntry(date: currentDate, quote: quote, isRevealed: true, language: language)
        } else {
            entry = QuoteEntry(date: currentDate, quote: nil, isRevealed: isRevealed, language: language)
        }
        
        // Update at midnight for the new day
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
        
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }
}

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: WidgetQuoteData?
    let isRevealed: Bool
    let language: String  // Include language for proper refresh when language changes
}

struct VibeFlipWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            if let quote = entry.quote {
                // Quote is revealed and we have the text - show it
                QuoteRevealedView(quote: quote, widgetFamily: widgetFamily)
            } else if entry.isRevealed {
                // Quote was revealed but we don't have text (widget added after reveal)
                // Show prompt to open app to sync
                QuoteRevealedNoDataView(widgetFamily: widgetFamily)
            } else {
                // Quote not revealed - show call to action
                QuoteNotRevealedView(widgetFamily: widgetFamily)
            }
        }
    }
}

struct VibeFlipWidget: Widget {
    let kind: String = "VibeFlipWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VibeFlipWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
        }
        .configurationDisplayName("Daily Vibe")
        .description("See your daily motivation quote.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    VibeFlipWidget()
} timeline: {
    QuoteEntry(date: .now, quote: WidgetQuoteData(text: "The only way to do great work is to love what you do.", action: "Take 5 minutes to reflect on what brings you joy."), isRevealed: true, language: "English")
    QuoteEntry(date: .now, quote: nil, isRevealed: false, language: "English")
}

#Preview(as: .systemMedium) {
    VibeFlipWidget()
} timeline: {
    QuoteEntry(date: .now, quote: WidgetQuoteData(text: "The only way to do great work is to love what you do.", action: "Take 5 minutes to reflect on what brings you joy."), isRevealed: true, language: "English")
    QuoteEntry(date: .now, quote: nil, isRevealed: false, language: "English")
}

#Preview(as: .systemLarge) {
    VibeFlipWidget()
} timeline: {
    QuoteEntry(date: .now, quote: WidgetQuoteData(text: "The only way to do great work is to love what you do.", action: "Take 5 minutes to reflect on what brings you joy."), isRevealed: true, language: "English")
    QuoteEntry(date: .now, quote: nil, isRevealed: false, language: "English")
}
