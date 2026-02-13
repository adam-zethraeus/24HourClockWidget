import AppIntents
import SwiftUI
import TwentyFourHourClock
import WidgetKit

// MARK: - ClockWidget

final class TwentyFourClockIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Clock 24"
}

struct TwentyFourHourEntry: TimelineEntry {
  var date: Date
  var showDate: Bool = true
}

struct ClockWidgetView: View {
  let date: Date
  let showDate: Bool
  var body: some View {
    ClockView(date: date, showDate: showDate, showSecondHand: false)
      .containerBackground(for: .widget) {
        Color.black
      }
  }
}

struct TwentyFourHourProvider: AppIntentTimelineProvider {
  func placeholder(in context: Context) -> TwentyFourHourEntry {
    .init(date: .now, showDate: false)
  }

  func timeline(for configuration: TwentyFourClockIntent, in context: Context) async -> Timeline<TwentyFourHourEntry> {
    let calendar = Calendar.current
    let now = Date.now

    // Round down to the start of the current minute.
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
    let startOfMinute = calendar.date(from: components) ?? now

    // Generate an entry for every minute for the next 6 hours.
    let entryCount = 360
    let entries = (0 ..< entryCount).map { minuteOffset in
      let date = startOfMinute.addingTimeInterval(Double(minuteOffset) * 60)
      return TwentyFourHourEntry(date: date)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }

  func snapshot(for configuration: TwentyFourClockIntent, in context: Context) async -> TwentyFourHourEntry {
    .init(date: .now)
  }
}

struct AppIntentClockWidget: Widget {
  let kind: String = "24HourClockWidget"

  var body: some WidgetConfiguration {
    AppIntentConfiguration<TwentyFourClockIntent, ClockWidgetView>(
      kind: kind, provider: TwentyFourHourProvider()
    ) { entry in
      ClockWidgetView(
        date: entry.date,
        showDate: entry.showDate
      )
    }
    .configurationDisplayName("Clock ㉔")
  }
}

// MARK: - ClockWidget_Previews

struct ClockWidget_Previews: PreviewProvider {
  static var previews: some View {
    ClockWidgetView(date: .now, showDate: true)
      .previewContext(
        WidgetPreviewContext(
          family: .systemSmall
        )
      )
  }
}
