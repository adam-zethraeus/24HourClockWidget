import SwiftUI

// MARK: - ClockView

public struct ClockView: View {

  // MARK: Lifecycle

  public init(
    date: Date,
    showDate: Bool,
    showSecondHand: Bool = true
  ) {
    self.date = date
    self.showDate = showDate
    self.showSecondHand = showSecondHand
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .center) {
      GeometryReader { proxy in
        let side: CGFloat = min(proxy.size.width, proxy.size.height)
        let step: CGFloat = side / 16.0
        ZStack {
          Background(step: step)
          Numbers(step: step)
          Ticks(step: step)
          if let angles {
            Hand.Fat(
              step: step,
              frontInset: step * 3.5,
              innerPadding: step*0.7,
              angle: angles.hour
            )
            Hand.Fat(
              step: step,
              frontInset: step * 0.7,
              innerPadding: step * 0.7,
              angle: angles.minute
            )
            if showSecondHand {
              Hand.Thin(
                step: step,
                frontInset: step * 0.7,
                backInset: step * 7.0,
                angle: angles.second
              )
            }
          }
          HandPin(step: step)
        }
        .frame(
          width: side,
          height: side
        )
      }
      .aspectRatio(1, contentMode: .fit)
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  // MARK: Internal

  var date: Date
  var showDate: Bool
  var showSecondHand: Bool

  var angles: HandAngles? {
    showDate
    ? HandAngles(date: date)
    : nil
  }

}

// MARK: - ClockView_PreviewProvider

struct ClockView_PreviewProvider: PreviewProvider {
  static var previews: some View {
    Group {
      ClockView(date:.now, showDate: true)
        .frame(width: 80, height: 80)
      ClockView(date:.now, showDate: true)
        .frame(width: 160, height: 160)
      ClockView(date:.now, showDate: true)
        .frame(width: 320, height: 320)
    }
    .background(.black)
    .previewLayout(.sizeThatFits)
  }
}
