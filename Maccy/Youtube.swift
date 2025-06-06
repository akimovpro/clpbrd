import Foundation

struct YoutubeTranscriptFetcher {
  struct Transcript: Codable {
    let text: String
  }

  static func videoID(from url: String) -> String? {
    if let match = url.range(of: "v=([\\w-]{11})", options: .regularExpression) {
      return String(url[match]).replacingOccurrences(of: "v=", with: "")
    }
    if let match = url.range(of: "youtu\\.be/([\\w-]{11})", options: .regularExpression) {
      return url[match].split(separator: "/").last.map(String.init)
    }
    return nil
  }

  static func fetchTranscript(for videoID: String, apiKey: String) async throws -> String {
    let urlString = "https://supadata.supabase.co/rest/v1/transcripts?video_id=eq.\(videoID)&select=text"
    guard let url = URL(string: urlString) else { throw NSError(domain: "InvalidURL", code: -1) }

    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey, forHTTPHeaderField: "apikey")
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let (data, _) = try await URLSession.shared.data(for: request)
    let transcripts = try JSONDecoder().decode([Transcript].self, from: data)
    return transcripts.map { $0.text }.joined(separator: " ")
  }
}
