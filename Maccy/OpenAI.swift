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

  struct VisionImageURL: Codable {
    let url: String
    let detail: String?
  }

  struct VisionContent: Codable {
    let type: String
    let text: String?
    let image_url: VisionImageURL?
  }

  struct VisionMessage: Codable {
    let role: String
    let content: [VisionContent]
  }

  struct VisionRequestBody: Codable {
    let model: String
    let messages: [VisionMessage]
  }

  static func chat(prompt: String, text: String, apiKey: String) async throws -> String {
    let maskedKey = apiKey.count > 14 ? "\(apiKey.prefix(10))...\(apiKey.suffix(4))" : "Invalid or too short key"
    NSLog("OpenAI.chat: Making request with API key: \(maskedKey)")

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
      if let http = response as? HTTPURLResponse {
        let body = String(data: data, encoding: .utf8) ?? "Could not decode body"
        NSLog("OpenAI API Error: Received status code \(http.statusCode). Body: \(body)")
      }
      throw OpenAIError.invalidResponse
    }
    let decoded = try JSONDecoder().decode(ResponseBody.self, from: data)
    return decoded.choices.first?.message.content ?? text
  }

  static func chat(prompt: String, imageData: Data, apiKey: String) async throws -> String {
    let maskedKey = apiKey.count > 14 ? "\(apiKey.prefix(10))...\(apiKey.suffix(4))" : "Invalid or too short key"
    NSLog("OpenAI.chat (vision): Making request with API key: \(maskedKey)")

    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let base64 = imageData.base64EncodedString()
    let dataUrl = "data:image/png;base64,\(base64)"

    let body = VisionRequestBody(
      model: "gpt-4o",
      messages: [
        VisionMessage(
          role: "system",
          content: [VisionContent(type: "text", text: prompt, image_url: nil)]
        ),
        VisionMessage(
          role: "user",
          content: [
            VisionContent(
              type: "image_url",
              text: nil,
              image_url: VisionImageURL(url: dataUrl, detail: "auto")
            )
          ]
        )
      ]
    )
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
      if let http = response as? HTTPURLResponse {
        let body = String(data: data, encoding: .utf8) ?? "Could not decode body"
        NSLog("OpenAI API Error: Received status code \(http.statusCode). Body: \(body)")
      }
      throw OpenAIError.invalidResponse
    }
    let decoded = try JSONDecoder().decode(ResponseBody.self, from: data)
    return decoded.choices.first?.message.content ?? ""
  }
}
