import Foundation

enum YouTubeError: Error {
  case invalidURL
  case invalidResponse
  case transcriptUnavailable
}

struct YouTube {
  static func isYouTubeURL(_ string: String) -> Bool {
    guard let url = URL(string: string.lowercased()) else { return false }
    if let host = url.host {
      return host.contains("youtube.com") || host.contains("youtu.be")
    }
    return false
  }

  static func videoID(from string: String) -> String? {
    guard let url = URL(string: string) else { return nil }
    if let host = url.host, host.contains("youtu.be") {
      return url.pathComponents.last
    }
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    return components?.queryItems?.first(where: { $0.name == "v" })?.value
  }

  static func fetchTranscript(videoID: String) async throws -> String {
    guard let url = URL(string: "https://video.google.com/timedtext?lang=en&v=\(videoID)") else {
      throw YouTubeError.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
      throw YouTubeError.invalidResponse
    }
    guard let xmlString = String(data: data, encoding: .utf8), !xmlString.isEmpty else {
      throw YouTubeError.transcriptUnavailable
    }
    return parseTranscript(xmlString)
  }

  private static func parseTranscript(_ xml: String) -> String {
    var result = ""
    let parser = XMLParser(data: xml.data(using: .utf8) ?? Data())
    class Delegate: NSObject, XMLParserDelegate {
      var text = ""
      func parser(_ parser: XMLParser, foundCharacters string: String) {
        text += string + " "
      }
    }
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
    result = delegate.text.replacingOccurrences(of: "\n", with: " ")
    return result
  }
}
