import SwiftUI
import TwentyFourHourClock
import WidgetKit

// MARK: - ClockWidget

struct ClockWidget: Widget {
  let kind: String = "24HourClockWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(
      kind: kind,
      intent: ConfigurationIntent.self,
      provider: TimelineProvider()
    ) { entry in
      TimelineView(
        .periodic(
          from: .now,
          by: 1
        )
      ) { _ in
        ClockView(
          date: entry.date
        ).background {
          Rectangle()
            .fill(.black)
        }
        .onAppear {
          Timer
            .scheduledTimer(
              withTimeInterval: 0.5,
              repeats: true
            ) { _ in
              WidgetCenter
                .shared
                .reloadTimelines(ofKind: "24HourClockWidget")
            }
        }
      }
    }
    .configurationDisplayName("24 Hour Clock")
    .description("24 Hour Analog Clock Widget")
  }
}

// MARK: - ClockWidget_Previews

struct ClockWidget_Previews: PreviewProvider {
  static var previews: some View {
    ClockView(date: .now)
      .previewContext(
        WidgetPreviewContext(
          family: .systemSmall
        )
      )
  }
}
