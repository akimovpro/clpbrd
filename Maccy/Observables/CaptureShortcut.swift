import KeyboardShortcuts

final class CaptureShortcut {
  init() {
    KeyboardShortcuts.onKeyUp(for: .capture) {
      Clipboard.shared.specialCopy()
    }
  }
}
