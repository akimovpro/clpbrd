import Defaults
import KeyboardShortcuts
import Observation

@Observable
final class Prompts {
  init() {
    KeyboardShortcuts.onKeyUp(for: .prompt1) { Defaults[.activePromptIndex] = 0 }
    KeyboardShortcuts.onKeyUp(for: .prompt2) { Defaults[.activePromptIndex] = 1 }
    KeyboardShortcuts.onKeyUp(for: .prompt3) { Defaults[.activePromptIndex] = 2 }
    KeyboardShortcuts.onKeyUp(for: .prompt4) { Defaults[.activePromptIndex] = 3 }
    KeyboardShortcuts.onKeyUp(for: .prompt5) { Defaults[.activePromptIndex] = 4 }
    KeyboardShortcuts.onKeyUp(for: .prompt6) { Defaults[.activePromptIndex] = 5 }
    KeyboardShortcuts.onKeyUp(for: .prompt7) { Defaults[.activePromptIndex] = 6 }
    KeyboardShortcuts.onKeyUp(for: .prompt8) { Defaults[.activePromptIndex] = 7 }
    KeyboardShortcuts.onKeyUp(for: .prompt9) { Defaults[.activePromptIndex] = 8 }
    KeyboardShortcuts.onKeyUp(for: .prompt10) { Defaults[.activePromptIndex] = 9 }
  }
}
