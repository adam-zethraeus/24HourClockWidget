import SwiftUI
import TwentyFourHourClock

// MARK: - ClockApp

@main
struct ClockApp: App {

  @State private var chrome = WindowChromeController()
  @State private var hovering = false

  var body: some Scene {
    WindowGroup {
      ZStack {
        BlackFrostedBackground()
          .ignoresSafeArea()
        Color.black.opacity(0.45)   // controls how dark the glass feels
                .ignoresSafeArea()
        TimelineView(.animation(minimumInterval: 0.1)) { context in
          ClockView(date: context.date, showDate: true)
        }
        .ignoresSafeArea()
      }
      .frame(minWidth: 220, minHeight: 220)
      .ignoresSafeArea()
      .background(
          WindowReader { w in
              chrome.window = w
              chrome.setButtonsVisible(false) // start dimmed
          }
      )
      .onHover { inside in
          hovering = inside
          chrome.setButtonsVisible(inside)
      }
      .background(WindowConfigurator())
      .background(.clear)
      .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
      
    }
    .windowStyle(.hiddenTitleBar)
    .windowToolbarStyle(.unifiedCompact)
    .windowBackgroundDragBehavior(.enabled)
    .windowResizability(.contentSize)
    .defaultSize(width: 400, height: 400)

  }
}

struct WindowReader: NSViewRepresentable {

    var onResolve: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let v = NSView()
        DispatchQueue.main.async {
            if let w = v.window {
                onResolve(w)
            }
        }
        return v
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

final class WindowChromeController: ObservableObject {

    weak var window: NSWindow?

    func setButtonsVisible(_ visible: Bool) {
        guard let window else { return }

        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.2
            let alpha: CGFloat = visible ? 1.0 : 0.25

            [.closeButton, .miniaturizeButton, .zoomButton]
                .compactMap { window.standardWindowButton($0) }
                .forEach { $0.animator().alphaValue = alpha }
        }
    }
}

struct BlackFrostedBackground: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let v = NSVisualEffectView()
        v.material = .hudWindow        // darkest built-in frosted style
        v.blendingMode = .behindWindow
        v.state = .active
        v.isEmphasized = true
      DispatchQueue.main.async {
          if let window = v.window {
              window.contentAspectRatio = NSSize(width: 1, height: 1)
            let buttons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]

            buttons.compactMap { window.standardWindowButton($0) }
                .forEach { button in
                    button.alphaValue = 0.15     // partially faded
                    button.isHidden = false      // keep them interactive
                }
          }
      }
        return v
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
struct WindowConfigurator: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.isOpaque = false
                window.backgroundColor = .clear
                window.titlebarAppearsTransparent = true
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ClockView(date: .now, showDate: true)
      .background(.black)
  }
}
