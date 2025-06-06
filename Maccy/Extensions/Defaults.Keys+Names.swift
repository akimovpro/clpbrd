import AppKit
import Defaults

struct StorageType {
  static let files = StorageType(types: [.fileURL])
  static let images = StorageType(types: [.png, .tiff])
  static let text = StorageType(types: [.html, .rtf, .string])
  static let all = StorageType(types: files.types + images.types + text.types)

  var types: [NSPasteboard.PasteboardType]
}

extension Defaults.Keys {
  static let clearOnQuit = Key<Bool>("clearOnQuit", default: false)
  static let clearSystemClipboard = Key<Bool>("clearSystemClipboard", default: false)
  static let clipboardCheckInterval = Key<Double>("clipboardCheckInterval", default: 0.5)
  static let enabledPasteboardTypes = Key<Set<NSPasteboard.PasteboardType>>(
    "enabledPasteboardTypes", default: Set(StorageType.all.types)
  )
  static let highlightMatch = Key<HighlightMatch>("highlightMatch", default: .bold)
  static let ignoreAllAppsExceptListed = Key<Bool>("ignoreAllAppsExceptListed", default: false)
  static let ignoreEvents = Key<Bool>("ignoreEvents", default: false)
  static let ignoreOnlyNextEvent = Key<Bool>("ignoreOnlyNextEvent", default: false)
  static let ignoreRegexp = Key<[String]>("ignoreRegexp", default: [])
  static let ignoredApps = Key<[String]>("ignoredApps", default: [])
  static let ignoredPasteboardTypes = Key<Set<String>>(
    "ignoredPasteboardTypes",
    default: Set([
      "Pasteboard generator type",
      "com.agilebits.onepassword",
      "com.typeit4me.clipping",
      "de.petermaurer.TransientPasteboardType",
      "net.antelle.keeweb"
    ])
  )
  static let imageMaxHeight = Key<Int>("imageMaxHeight", default: 40)
  static let lastReviewRequestedAt = Key<Date>("lastReviewRequestedAt", default: Date.now)
  static let menuIcon = Key<MenuIcon>("menuIcon", default: .maccy)
  static let migrations = Key<[String: Bool]>("migrations", default: [:])
  static let numberOfUsages = Key<Int>("numberOfUsages", default: 0)
  static let pasteByDefault = Key<Bool>("pasteByDefault", default: false)
  static let pinTo = Key<PinsPosition>("pinTo", default: .top)
  static let popupPosition = Key<PopupPosition>("popupPosition", default: .cursor)
  static let popupScreen = Key<Int>("popupScreen", default: 0)
  static let previewDelay = Key<Int>("previewDelay", default: 1500)
  static let removeFormattingByDefault = Key<Bool>("removeFormattingByDefault", default: false)
  static let searchMode = Key<Search.Mode>("searchMode", default: .exact)
  static let showFooter = Key<Bool>("showFooter", default: true)
  static let showInStatusBar = Key<Bool>("showInStatusBar", default: true)
  static let showRecentCopyInMenuBar = Key<Bool>("showRecentCopyInMenuBar", default: false)
  static let showSearch = Key<Bool>("showSearch", default: true)
  static let searchVisibility = Key<SearchVisibility>("searchVisibility", default: .always)
  static let showSpecialSymbols = Key<Bool>("showSpecialSymbols", default: true)
  static let showTitle = Key<Bool>("showTitle", default: true)
  static let size = Key<Int>("historySize", default: 200)
  static let sortBy = Key<Sorter.By>("sortBy", default: .lastCopiedAt)
  static let suppressClearAlert = Key<Bool>("suppressClearAlert", default: false)
  static let windowSize = Key<NSSize>("windowSize", default: NSSize(width: 450, height: 800))
  static let windowPosition = Key<NSPoint>("windowPosition", default: NSPoint(x: 0.5, y: 0.8))
  static let showApplicationIcons = Key<Bool>("showApplicationIcons", default: false)
  static let aiEnabled = Key<Bool>("aiEnabled", default: false)
  static let openAIKey = Key<String>("openAIKey", default: "")
  static let supabaseKey = Key<String>("supabaseKey", default: "")
  static let openAIPrompts = Key<[String]>(
    "openAIPrompts",
    default: [
      "Summarize the copied text in 3 paragraphs.\nFocus on key facts only.",
      "Translate the copied text to Spanish.\nKeep formatting as close as possible.",
      "List main ideas as bullet points.\nUse one short phrase per bullet.",
      "Explain the meaning in simple terms.\nAvoid jargon or complex vocabulary.",
      "Rewrite the text to be more formal.\nRemove any casual expressions.",
      "Condense the text into one paragraph.\nKeep critical details intact.",
      "Generate a short title for the text.\nReturn just the title.",
      "Correct grammar mistakes in the text.\nDon't change its tone.",
      "Explain the text as if to a child.\nUse analogies where helpful.",
      "Create an outline of key points.\nUse numbered sections."
    ]
  )
  static let activePromptIndex = Key<Int>("activePromptIndex", default: 0)
}
