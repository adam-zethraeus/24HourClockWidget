import SwiftUI

extension ClockView {

  struct Background: View {
    let step: CGFloat
    var body: some View {
      ZStack {
        Circle()
          .foregroundColor(.black)
          .padding(step * 0.2)
        Circle()
          .foregroundColor(.gray)
          .padding(step * 0.3)
        Circle()
          .foregroundColor(.white)
          .padding(step * 0.5)
        Circle()
          .foregroundColor(.black)
          .frame(
            width: step,
            height: step
          )
      }
    }
  }

  struct HandPin: View {
    let step: CGFloat
    var body: some View {
      Circle()
        .foregroundColor(.white)
        .frame(
          width: step * 0.2,
          height: step * 0.2
        )
    }
  }

  struct Ticks: View {

    struct Tick: Shape {
      let inset: Double
      let length: Double
      func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(
          to: CGPoint(
            x: rect.midX,
            y: rect.minY + inset
          )
        )
        path.addLine(
          to: CGPoint(
            x: rect.midX,
            y: rect.minY + inset + length
          )
        )
        return path
      }
    }

    let step: CGFloat

    var body: some View {
      ZStack {
        ForEach(0 ..< 24) { position in
          let isFiveSeconds = position % 2 == 0
          let length: CGFloat = isFiveSeconds ? step * 1.2 : step * 0.4
          Tick(
            inset: step * 2.5,
            length: length
          )
          .stroke(lineWidth: step * 0.02)
          .rotationEffect(
            .radians(Double.pi * 2 / 24 * Double(position))
          )
        }
      }
      .foregroundColor(
        .init(red: 34 / 255, green: 34 / 255, blue: 34 / 255)
      )
    }
  }

  struct Number: View {
    let step: CGFloat
    let hour: Int
    var body: some View {
      VStack {
        Text("\(hour)")
          .font(
            .custom(
              "Futura",
              fixedSize: step * 0.9
            )
            .weight(.light)
          )
          .foregroundColor(.black)
          .rotationEffect(
            .radians(
              -(Double.pi * 2 / 24 * Double(hour))
            )
          )
        Spacer()
      }
      .padding(step * 0.8)
      .rotationEffect(
        .radians(
          Double.pi * 2 / 24 * Double(hour)
        )
      )
    }
  }

  struct Numbers: View {
    let step: CGFloat
    var body: some View {
      ZStack {
        ForEach(0 ..< 24) { hour in
          Number(
            step: step,
            hour: hour + 1
          )
        }
      }
    }
  }

  enum Hand {

    // MARK: Internal

    struct Thin: View {

      let step: CGFloat
      let frontInset: CGFloat
      let backInset: CGFloat
      let angle: CGFloat

      var body: some View {
        ZStack {
          HandPath(
            frontInset: frontInset,
            innerPadding: 0
          )
          .fill()
          .foregroundColor(.red)
          .frame(width: step * 0.1)
          .rotationEffect(.radians(angle))
          .shadow(radius: step * 0.4)

          HandPath(
            frontInset: backInset,
            innerPadding: 0
          )
          .fill()
          .foregroundColor(.red)
          .frame(width: step * 0.1)
          .rotationEffect(.radians(Double.pi + angle))
          .shadow(radius: step * 0.4)

          Circle()
            .fill()
            .foregroundColor(.red)
            .frame(width: step * 0.7, height: step * 0.7)
        }
      }
    }

    struct Fat: View {

      let step: CGFloat
      let frontInset: CGFloat
      let innerPadding: CGFloat
      let angle: CGFloat

      var body: some View {
        ZStack {
          HandPath(
            frontInset: frontInset,
            innerPadding: innerPadding
          )
          .fill()
          .foregroundColor(.black)
          .frame(width: step * 0.4, alignment: .center)
          .rotationEffect(.radians(angle))
          .shadow(radius: step * 0.4)
          HandPath(
            frontInset: frontInset,
            innerPadding: 0
          )
          .fill()
          .foregroundColor(.black)
          .frame(width: step * 0.1, alignment: .center)
          .rotationEffect(.radians(angle))
          .shadow(radius: step * 0.4)
        }
      }
    }

    // MARK: Private

    private struct HandPath: Shape {
      let frontInset: CGFloat
      let innerPadding: CGFloat
      func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
          in: CGRect(
            origin: CGPoint(
              x: rect.origin.x,
              y: rect.origin.y + frontInset
            ),
            size: CGSize(
              width: rect.width,
              height: (rect.height / 2) - innerPadding - frontInset
            )
          ),
          cornerSize: CGSize(
            width: rect.width / 2,
            height: rect.width / 2
          )
        )
        return path
      }
    }
  }

}
