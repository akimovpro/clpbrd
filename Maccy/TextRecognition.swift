import AppKit
import Carbon
import NaturalLanguage
import Vision

enum TextRecognitionError: Error {
  case invalidImage
}

struct TextRecognition {
  static func recognize(imageData: Data) async throws -> String {
    guard let image = NSImage(data: imageData),
          let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      throw TextRecognitionError.invalidImage
    }

    let allLanguages = ["en"] + inputSourceLanguages()
    let (text, detected) = try await recognize(cgImage: cgImage, languages: allLanguages)

    guard let detected, detected != "en" else {
      return text
    }

    let finalLanguages = Array(Set(["en", detected]))
    let (finalText, _) = try await recognize(cgImage: cgImage, languages: finalLanguages)
    return finalText
  }

  private static func recognize(cgImage: CGImage, languages: [String]) async throws -> (String, String?) {
    return try await withCheckedThrowingContinuation { continuation in
      let request = VNRecognizeTextRequest { request, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }

        let observations = request.results as? [VNRecognizedTextObservation] ?? []
        let candidates = observations.compactMap { $0.topCandidates(1).first }
        let text = candidates.map { $0.string }.joined(separator: "\n")
        let language = NLLanguageRecognizer.dominantLanguage(for: text)?.rawValue
        continuation.resume(returning: (text, language))
      }
      request.recognitionLevel = .fast
      request.recognitionLanguages = languages

      let handler = VNImageRequestHandler(cgImage: cgImage)
      do {
        try handler.perform([request])
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }

  private static func inputSourceLanguages() -> [String] {
    var languages = Set<String>()
    if let list = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
      for source in list {
        if let value = TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages) {
          let arr = Unmanaged<CFArray>.fromOpaque(value).takeUnretainedValue() as NSArray
          for case let lang as String in arr {
            languages.insert(lang)
          }
        }
      }
    }
    return Array(languages)
  }
}
