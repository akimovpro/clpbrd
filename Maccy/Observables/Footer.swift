import Defaults
import SwiftUI

@Observable
class Footer {
  var items: [FooterItem] = []
  private var aiItem: FooterItem!

  var selectedItem: FooterItem? {
    willSet {
      selectedItem?.isSelected = false
      newValue?.isSelected = true
    }
  }

  var suppressClearAlert = Binding<Bool>(
    get: { Defaults[.suppressClearAlert] },
    set: { Defaults[.suppressClearAlert] = $0 }
  )

  init() { // swiftlint:disable:this function_body_length
    aiItem = FooterItem(
      title: Defaults[.aiEnabled] ? "ai_disable" : "ai_enable",
      help: Defaults[.aiEnabled] ? "ai_disable_tooltip" : "ai_enable_tooltip"
    ) {
      AppState.shared.toggleAI()
    }

    items = [
      FooterItem(
        title: "clear",
        shortcuts: [KeyShortcut(key: .delete, modifierFlags: [.command, .option])],
        help: "clear_tooltip",
        confirmation: .init(
          message: "clear_alert_message",
          comment: "clear_alert_comment",
          confirm: "clear_alert_confirm",
          cancel: "clear_alert_cancel"
        ),
        suppressConfirmation: suppressClearAlert
      ) {
        Task { @MainActor in
          AppState.shared.history.clear()
        }
      },
      FooterItem(
        title: "clear_all",
        shortcuts: [KeyShortcut(key: .delete, modifierFlags: [.command, .option, .shift])],
        help: "clear_all_tooltip",
        confirmation: .init(
          message: "clear_alert_message",
          comment: "clear_alert_comment",
          confirm: "clear_alert_confirm",
          cancel: "clear_alert_cancel"
        ),
        suppressConfirmation: suppressClearAlert
      ) {
        Task { @MainActor in
          AppState.shared.history.clearAll()
        }
      },
      FooterItem(
        title: "preferences",
        shortcuts: [KeyShortcut(key: .comma)]
      ) {
        Task { @MainActor in
          AppState.shared.openPreferences()
        }
      },
      FooterItem(
        title: "about",
        help: "about_tooltip"
      ) {
        AppState.shared.openAbout()
      },
      aiItem,
      FooterItem(
        title: "quit",
        shortcuts: [KeyShortcut(key: .q)],
        help: "quit_tooltip"
      ) {
        AppState.shared.quit()
      }
    ]

    updateAIToggle()

    Task {
      for await value in Defaults.updates(.aiEnabled) {
        await MainActor.run {
          self.updateAIToggle(value)
        }
      }
    }
  }

  @MainActor
  private func updateAIToggle(_ enabled: Bool = Defaults[.aiEnabled]) {
    aiItem.title = enabled ? "ai_disable" : "ai_enable"
    aiItem.help = LocalizedStringKey(enabled ? "ai_disable_tooltip" : "ai_enable_tooltip")
  }
}
