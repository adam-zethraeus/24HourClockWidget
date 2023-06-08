import SwiftUI
import TwentyFourHourClock

// MARK: - ClockApp

@main
struct ClockApp: App {

  @State var date: Date = .now

  var body: some Scene {
    WindowGroup {
      ClockView(date: date)
        .background(.black)
        .onAppear {
          Timer.scheduledTimer(
            withTimeInterval: 0.2,
            repeats: true
          ) { _ in
            date = .now
          }
        }
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ClockView(date: .now)
      .background(.black)
  }
}
