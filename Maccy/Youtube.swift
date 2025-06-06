import Foundation

struct YoutubeTranscriptFetcher {
  struct Transcript: Codable {
    let content: String
  }

  static func videoID(from url: String) -> String? {
    let patterns = [
      "v=([\\w-]{11})",
      "youtu\\.be/([\\w-]{11})",
      "youtube\\.com/(?:shorts|embed|v)/([\\w-]{11})"
    ]

    for pattern in patterns {
      if let regex = try? NSRegularExpression(pattern: pattern) {
        let range = NSRange(url.startIndex..<url.endIndex, in: url)
        if let match = regex.firstMatch(in: url, range: range) {
          if let idRange = Range(match.range(at: 1), in: url) {
            return String(url[idRange])
          }
        }
      }
    }
    return nil
  }

  static func fetchTranscript(for videoID: String, apiKey: String) async throws -> String {
    let urlString = "https://api.supadata.ai/v1/youtube/transcript?videoId=\(videoID)&text=true"
    guard let url = URL(string: urlString) else { throw NSError(domain: "InvalidURL", code: -1) }

    var request = URLRequest(url: url)
    request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

    let (data, _) = try await URLSession.shared.data(for: request)
    let transcript = try JSONDecoder().decode(Transcript.self, from: data)
    return transcript.content
  }
}
