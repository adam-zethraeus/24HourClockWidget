import SwiftUI
import TwentyFourHourClock
import WidgetKit
import AppIntents

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
    ClockView(date: date, showDate: showDate)
      .containerBackground(for: .widget) {
        Color.black
      }.onAppear {
        Timer
          .scheduledTimer(
            withTimeInterval: 60,
            repeats: true
          ) { _ in
            WidgetCenter
              .shared
              .reloadTimelines(ofKind: "24HourClockWidget")
          }
      }
  }
}

  struct TwentyFourHourProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TwentyFourHourEntry {
      .init(date: .now, showDate: false)
    }

    func timeline(for configuration: TwentyFourClockIntent, in context: Context) async -> Timeline<TwentyFourHourEntry> {
      let now = Date.now
      let entries = stride(from: 0, to: 120, by: 1)
        .map { offset in
          now.addingTimeInterval(offset)
        }
        .map { TwentyFourHourEntry(date: $0) }

      return .init(entries: entries, policy: .after(now.advanced(by: 90)))
    }

    func snapshot(for configuration: TwentyFourClockIntent, in context: Context) async -> TwentyFourHourEntry {
      .init(date: .now)
    }
  }

  struct AppIntentClockWidget: Widget {
    let kind: String = "24HourClockWidget"

    var body: some WidgetConfiguration {
      AppIntentConfiguration<TwentyFourClockIntent, ClockWidgetView>(
        kind: kind, provider: TwentyFourHourProvider()) { entry in
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
