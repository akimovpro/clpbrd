import AppKit
import UserNotifications

class Notifier {
  private static var center: UNUserNotificationCenter { UNUserNotificationCenter.current() }
  private static var isAuthorizationRequested = false

  private static var shouldSkipNotifications: Bool {
    let env = ProcessInfo.processInfo.environment
    return CommandLine.arguments.contains("enable-testing") ||
      env["CI"] != nil ||
      env["MACCY_DISABLE_NOTIFICATIONS"] != nil
  }

  static func authorize() {
    guard !isAuthorizationRequested else { return }
    isAuthorizationRequested = true

    guard !shouldSkipNotifications else { return }

    center.requestAuthorization(options: [.alert, .sound]) { _, error in
      if error != nil {
        NSLog("Failed to authorize notifications: \(String(describing: error))")
      }
    }
  }

  static func notify(body: String?, sound: NSSound?) {
    guard let body, !shouldSkipNotifications else { return }

    authorize()

    center.getNotificationSettings { settings in
      guard (settings.authorizationStatus == .authorized) ||
            (settings.authorizationStatus == .provisional) else { return }

      let content = UNMutableNotificationContent()
      if settings.alertSetting == .enabled {
        content.body = body
      }

      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
      center.add(request) { error in
        if error != nil {
          NSLog("Failed to deliver notification: \(String(describing: error))")
        } else {
          if settings.soundSetting == .enabled {
            sound?.play()
          }
        }
      }
    }
  }
}
