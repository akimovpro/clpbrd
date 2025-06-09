import KeyboardShortcuts

@Observable
final class CaptureShortcut {
  init() {
    KeyboardShortcuts.onKeyUp(for: .capture) {
      Clipboard.shared.specialCopy()
    }
  }
}
