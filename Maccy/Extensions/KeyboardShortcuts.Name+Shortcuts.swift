import KeyboardShortcuts

extension KeyboardShortcuts.Name {
  static let popup = Self("popup", default: Shortcut(.c, modifiers: [.command, .shift]))
  static let pin = Self("pin", default: Shortcut(.p, modifiers: [.option]))
  static let delete = Self("delete", default: Shortcut(.delete, modifiers: [.option]))
  static let prompt1 = Self("prompt1", default: Shortcut(.one, modifiers: [.control, .option]))
  static let prompt2 = Self("prompt2", default: Shortcut(.two, modifiers: [.control, .option]))
  static let prompt3 = Self("prompt3", default: Shortcut(.three, modifiers: [.control, .option]))
  static let prompt4 = Self("prompt4", default: Shortcut(.four, modifiers: [.control, .option]))
  static let prompt5 = Self("prompt5", default: Shortcut(.five, modifiers: [.control, .option]))
  static let prompt6 = Self("prompt6", default: Shortcut(.six, modifiers: [.control, .option]))
  static let prompt7 = Self("prompt7", default: Shortcut(.seven, modifiers: [.control, .option]))
  static let prompt8 = Self("prompt8", default: Shortcut(.eight, modifiers: [.control, .option]))
  static let prompt9 = Self("prompt9", default: Shortcut(.nine, modifiers: [.control, .option]))
  static let prompt10 = Self("prompt10", default: Shortcut(.zero, modifiers: [.control, .option]))
  static let toggleAI = Self("toggleAI", default: Shortcut(.a, modifiers: [.command, .option]))
  static let capture = Self("capture", default: Shortcut(.c, modifiers: [.command, .control]))
}
