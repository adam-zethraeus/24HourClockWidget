import SwiftUI

extension ClockView {

  struct Background: View {
    let step: CGFloat
    var body: some View {

        // Clock face — radial gradient adds subtle depth
        Circle()
          .fill(
            RadialGradient(
              gradient: Gradient(stops: [
                .init(color: Color(white: 0.97), location: 0.0),
                .init(color: Color(white: 0.94), location: 0.7),
                .init(color: Color(white: 0.90), location: 1.0),
              ]),
              center: .center,
              startRadius: 0,
              endRadius: step * 7.5
            )
          )
          .padding(step * 0.5)
          .shadow(color: .black.opacity(0.5), radius: step * 0.15)
    }
  }

  struct HandPin: View {
    let step: CGFloat
    var body: some View {
      ZStack {
        Circle()
          .fill(Color(white: 0.95))
          .frame(width: step * 0.15, height: step * 0.15)
      }
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
        ForEach(0 ..< 120, id: \.self) { position in
          let s = position % 5

          let t = switch s {
          case 0:
            Tick(inset: step * 0.7, length: step * 0.8)
          case 1:
            Tick(inset: step * 0.7, length: step * 0.55)
          case 2:
            Tick(inset: step * 0.7, length: step * 0.55)
          case 3:
            Tick(inset: step * 0.7, length: step * 0.55)
          case 4:
            Tick(inset: step * 0.7, length: step * 0.55)
          default:
            fatalError()
          }
          t
          .stroke(
            Color(white: 0.12),
            style: StrokeStyle(
              lineWidth: step * (s == 0 ? 0.045 : 0.015),
              lineCap: .round
            )
          )
          .rotationEffect(
            .radians(Double.pi * 2 / 120 * Double(position))
          )
        }
      }
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
              fixedSize: step * 0.85
            )
            .weight(.light)
          )
          .foregroundColor(Color(white: 0.1))
          .rotationEffect(
            .radians(
              -(Double.pi * 2.0 / 24.0 * Double(hour))
            )
          )
        Spacer()
      }
      .padding(step * 1.6)
      .rotationEffect(
        .radians(
          Double.pi * 2.0 / 24.0 * Double(hour)
        )
      )
    }
  }

  struct Numbers: View {
    let step: CGFloat
    var body: some View {
      ZStack {
        ForEach(0 ..< 24, id: \.self) { hour in
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
          .frame(width: step * 0.08)
          .rotationEffect(.radians(angle))
          .shadow(color: .black.opacity(0.2), radius: step * 0.25, y: step * 0.06)

          HandPath(
            frontInset: backInset,
            innerPadding: 0
          )
          .fill()
          .foregroundColor(.red)
          .frame(width: step * 0.12)
          .rotationEffect(.radians(Double.pi + angle))
          .shadow(color: .black.opacity(0.2), radius: step * 0.25, y: step * 0.06)

          Circle()
            .fill()
            .foregroundColor(.red)
            .frame(width: step * 0.6, height: step * 0.6)
            .shadow(color: .black.opacity(0.15), radius: step * 0.1)
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
          .foregroundColor(Color(white: 0.08))
          .frame(width: step * 0.35, alignment: .center)
          .rotationEffect(.radians(angle))
          .shadow(color: .black.opacity(0.25), radius: step * 0.25, y: step * 0.06)
          HandPath(
            frontInset: frontInset,
            innerPadding: 0
          )
          .fill()
          .foregroundColor(Color(white: 0.08))
          .frame(width: step * 0.1, alignment: .center)
          .rotationEffect(.radians(angle))
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
