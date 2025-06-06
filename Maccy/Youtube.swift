import Foundation

class YoutubeTranscriptFetcher {
  struct Transcript: Codable {
    let text: String
  }

  static func fetchTranscript(for videoID: String,
                              apiKey: String,
                              completion: @escaping (Result<String, Error>) -> Void) {
    let urlString = "https://supadata.supabase.co/rest/v1/transcripts?video_id=eq.\(videoID)&select=text"
    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "InvalidURL", code: -1)))
      return
    }

    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey, forHTTPHeaderField: "apikey")
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard let data = data else {
        completion(.failure(NSError(domain: "NoData", code: -1)))
        return
      }

      do {
        let transcripts = try JSONDecoder().decode([Transcript].self, from: data)
        let fullText = transcripts.map { $0.text }.joined(separator: " ")
        completion(.success(fullText))
      } catch {
        completion(.failure(error))
      }
    }

    task.resume()
  }
}
