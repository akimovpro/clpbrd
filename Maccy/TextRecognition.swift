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

    // Start with automatic language detection without restricting languages
    let (initialText, _) = try await recognize(cgImage: cgImage, languages: [])
    let inputLanguages = await inputSourceLanguages()
    let allLanguages = ["en"] + inputLanguages
    let (_, detected) = try await recognize(cgImage: cgImage, languages: allLanguages)

    // If language couldn't be detected, just return whatever was recognised
    guard let detected else { return initialText }

    // Combine detected language with user input sources and English fallback
    var languages = await inputSourceLanguages()
    languages.append("en")
    languages.append(detected)
    let finalLanguages = Array(Set(languages))

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
      if !languages.isEmpty {
        request.recognitionLanguages = languages
      }

      let handler = VNImageRequestHandler(cgImage: cgImage)
      do {
        try handler.perform([request])
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }

  @MainActor
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
