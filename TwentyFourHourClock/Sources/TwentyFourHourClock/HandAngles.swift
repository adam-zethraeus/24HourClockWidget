import Foundation

struct HandAngles: Hashable {
  init?(date: Date) {
    let calendar = Calendar.current
    let dateComponents = calendar
      .dateComponents(
        [.hour, .minute, .second],
        from: date
      )
    if
      let hour = dateComponents.hour,
      let minute = dateComponents.minute,
      let second = dateComponents.second
    {
      let radianInOneHour = 2 * Double.pi / 24
      let radianInOneMinute = 2 * Double.pi / 60
      self.minute = Double(minute) * radianInOneMinute
      let actualHour = Double(hour) + (Double(minute) / 60)
      self.hour = actualHour * radianInOneHour
      self.second = Double(second) * radianInOneMinute
    } else {
      return nil
    }
  }

  let minute: Double
  let hour: Double
  let second: Double
}
