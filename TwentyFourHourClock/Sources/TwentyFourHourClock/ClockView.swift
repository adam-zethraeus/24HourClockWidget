import SwiftUI

// MARK: - ClockView

public struct ClockView: View {

  // MARK: Lifecycle

  public init(
    date: Date,
    showDate: Bool
  ) {
    self.date = date
    self.showDate = showDate
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .center) {
      GeometryReader { proxy in
        let side: CGFloat = min(proxy.size.width, proxy.size.height)
        let step: CGFloat = side / 16
        ZStack {
          Background(step: step)
          Numbers(step: step)
          Ticks(step: step)
          if let angles {
            Hand.Fat(
              step: step,
              frontInset: step * 3.5,
              innerPadding: step,
              angle: angles.hour
            )
            Hand.Fat(
              step: step,
              frontInset: step * 2.5,
              innerPadding: step,
              angle: angles.minute
            )
            Hand.Thin(
              step: step,
              frontInset: step * 2.1,
              backInset: step * 7,
              angle: angles.second
            )
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
      .background {
        Rectangle()
          .fill(.black)
      }
  }

  // MARK: Internal

  var date: Date
  var showDate: Bool

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
