import SwiftUI
import WidgetKit

struct TimelineProvider: IntentTimelineProvider {

  struct DateEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
  }

  func placeholder(
    in _: Context
  )
    -> DateEntry
  {
    DateEntry(
      date: .now,
      configuration: ConfigurationIntent()
    )
  }

  func getSnapshot(
    for configuration: ConfigurationIntent,
    in _: Context,
    completion: @escaping (DateEntry) -> Void
  ) {
    let entry = DateEntry(
      date: .now,
      configuration: configuration
    )
    completion(entry)
  }

  func getTimeline(
    for configuration: ConfigurationIntent,
    in _: Context,
    completion: @escaping (Timeline<DateEntry>) -> Void
  ) {
    var entries: [DateEntry] = []
    let currentDate: Date = .now

    for minuteOffset in 0 ..< 60 {
      let entryDate = Calendar
        .current
        .date(
          byAdding: .minute,
          value: minuteOffset,
          to: currentDate
        )!
      let entry = DateEntry(
        date: entryDate,
        configuration: configuration
      )
      entries.append(entry)
    }

    let timeline = Timeline(
      entries: entries,
      policy: .atEnd
    )
    completion(timeline)
  }
}
