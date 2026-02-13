import SwiftUI
import TwentyFourHourClock

// MARK: - ClockApp

@main
struct ClockApp: App {

  var body: some Scene {
    WindowGroup {
      TimelineView(.periodic(from: .now, by: 1.0)) { context in
        ClockView(date: context.date, showDate: true)
      }
      .background(.black)
    }
    #if os(macOS)
    .windowResizability(.contentSize)
    #endif
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ClockView(date: .now, showDate: true)
      .background(.black)
  }
}
