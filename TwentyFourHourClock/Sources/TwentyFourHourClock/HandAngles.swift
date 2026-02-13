import Foundation

struct HandAngles: Hashable {
  init?(date: Date) {
    let calendar = Calendar.current
    let dateComponents = calendar
      .dateComponents(
        [.hour, .minute, .second, .nanosecond],
        from: date
      )
    guard
      let hour = dateComponents.hour,
      let minute = dateComponents.minute,
      let second = dateComponents.second,
      let nanosecond = dateComponents.nanosecond
    else { return nil }

    let radianInOneHour = 2 * Double.pi / 24
    let radianInOneMinute = 2 * Double.pi / 60

    // Fractional seconds for smooth sweep
    let fractionalSecond = Double(second) + Double(nanosecond) / 1_000_000_000
    self.second = fractionalSecond * radianInOneMinute

    // Minute hand creeps forward with each second
    let totalMinutes = Double(minute) + fractionalSecond / 60.0
    self.minute = totalMinutes * radianInOneMinute

    // Hour hand creeps forward with each minute
    let totalHours = Double(hour) + totalMinutes / 60.0
    self.hour = totalHours * radianInOneHour
  }

  let minute: Double
  let hour: Double
  let second: Double
}
