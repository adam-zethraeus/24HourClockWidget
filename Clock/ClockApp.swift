import SwiftUI
import TwentyFourHourClock

// MARK: - ClockApp

@main
struct ClockApp: App {

  @State var date: Date = .now

  var body: some Scene {
    WindowGroup {
        ClockView(date: date, showDate: true)
          .background(.black)
          .onAppear {
            Timer.scheduledTimer(
              withTimeInterval: 1,
              repeats: true
            ) { _ in
              date = .now
            }
          }
      }
    .windowResizability(.contentSize)
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ClockView(date: .now, showDate: true)
      .background(.black)
  }
}
