import SwiftUI
import TwentyFourHourClock
import WidgetKit

// MARK: - ClockEntry

struct ClockEntry: TimelineEntry {
  let date: Date
  let timeZone: TimeZone
  let timeZoneLabel: String
}

// MARK: - ClockTimelineProvider

struct ClockTimelineProvider: AppIntentTimelineProvider {

  func placeholder(in context: Context) -> ClockEntry {
    ClockEntry(date: .now, timeZone: .current, timeZoneLabel: "")
  }

  func snapshot(for configuration: ClockWidgetIntent, in context: Context) async -> ClockEntry {
    let tz = resolvedTimeZone(from: configuration)
    return ClockEntry(date: .now, timeZone: tz, timeZoneLabel: tz.displayLabel)
  }

  func timeline(for configuration: ClockWidgetIntent, in context: Context) async -> Timeline<ClockEntry> {
    let tz = resolvedTimeZone(from: configuration)
    let label = tz.displayLabel

    let calendar = Calendar.current
    let now = Date.now

    // Round down to the start of the current second.
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
    let startOfSecond = calendar.date(from: components) ?? now

    // Generate an entry every second for 1 hour.
    let entryCount = 3600
    let entries = (0 ..< entryCount).map { secondOffset in
      let date = startOfSecond.addingTimeInterval(Double(secondOffset))
      return ClockEntry(date: date, timeZone: tz, timeZoneLabel: label)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }

  private func resolvedTimeZone(from configuration: ClockWidgetIntent) -> TimeZone {
    if let detail = configuration.timezone,
       let tz = TimeZone(identifier: detail.id)
    {
      return tz
    }
    return .current
  }
}

// MARK: - ClockWidgetView

struct ClockWidgetView: View {
  let entry: ClockEntry
  @Environment(\.widgetFamily) var family

  var body: some View {
    switch family {
    case .systemSmall:
      smallView
    case .systemMedium:
      mediumView
    case .systemLarge:
      largeView
    default:
      smallView
    }
  }

  // Small: just the clock face, filling the space.
  private var smallView: some View {
    ClockView(
      date: entry.date,
      showDate: true,
      showSecondHand: true,
      timeZone: entry.timeZone
    )
    .padding(4)
  }

  // Medium: clock on the left, timezone info on the right.
  private var mediumView: some View {
    HStack(spacing: 0) {
      ClockView(
        date: entry.date,
        showDate: true,
        showSecondHand: true,
        timeZone: entry.timeZone
      )
      .padding(4)

      VStack(alignment: .leading, spacing: 6) {
        Text(timeString)
          .font(.system(.title, design: .rounded, weight: .medium))
          .monospacedDigit()
        Text(entry.timeZoneLabel)
          .font(.system(.caption, design: .rounded))
          .foregroundStyle(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.trailing, 12)
    }
  }

  // Large: bigger clock with timezone label underneath.
  private var largeView: some View {
    VStack(spacing: 8) {
      ClockView(
        date: entry.date,
        showDate: true,
        showSecondHand: true,
        timeZone: entry.timeZone
      )
      .padding(8)

      VStack(spacing: 2) {
        Text(timeString)
          .font(.system(.title2, design: .rounded, weight: .medium))
          .monospacedDigit()
        Text(entry.timeZoneLabel)
          .font(.system(.caption, design: .rounded))
          .foregroundStyle(.secondary)
      }
      .padding(.bottom, 12)
    }
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.timeZone = entry.timeZone
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: entry.date)
  }
}

// MARK: - Widget24

struct Widget24: Widget {
  let kind: String = "widget24"

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ClockWidgetIntent.self,
      provider: ClockTimelineProvider()
    ) { entry in
      ClockWidgetView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Clock ㉔")
    .description("A 24-hour analog clock.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
