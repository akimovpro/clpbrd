import Foundation
import Defaults

enum OpenAIError: Error {
  case invalidResponse
}

struct OpenAI {
  struct Message: Codable {
    let role: String
    let content: String
  }

  struct RequestBody: Codable {
    let model: String
    let messages: [Message]
  }

  struct ResponseBody: Codable {
    struct Choice: Codable {
      let message: Message
    }
    let choices: [Choice]
  }

  static func chat(prompt: String, text: String, apiKey: String) async throws -> String {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = RequestBody(
      model: "gpt-4o",
      messages: [
        Message(role: "system", content: prompt),
        Message(role: "user", content: text)
      ]
    )
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
      throw OpenAIError.invalidResponse
    }
    let decoded = try JSONDecoder().decode(ResponseBody.self, from: data)
    return decoded.choices.first?.message.content ?? text
  }
}
