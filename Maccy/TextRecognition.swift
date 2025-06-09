import AppKit
import Carbon
import Foundation
import NaturalLanguage
import Vision

enum TextRecognitionError: Error {
    case invalidImage
    case recognitionFailed(Error)
}

struct TextRecognition {
    static func recognize(imageData: Data) async throws -> String {
        guard let image = NSImage(data: imageData),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw TextRecognitionError.invalidImage
        }

        let (initialText, _) = try await recognize(cgImage: cgImage, languages: [])
        let inputLanguages = await inputSourceLanguages()
        let allLanguages = ["en"] + inputLanguages
        let (_, detected) = try await recognize(cgImage: cgImage, languages: allLanguages)

        guard let detected else { return initialText }

        var languages = await inputSourceLanguages()
        languages.append("en")
        languages.append(detected)
        let finalLanguages = Array(Set(languages))

        let (finalText, _) = try await recognize(cgImage: cgImage, languages: finalLanguages)
        return finalText
    }

    private static func recognize(cgImage: CGImage, languages: [String]) async throws -> (String, String?) {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: TextRecognitionError.recognitionFailed(error))
                    return
                }

                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let candidates = observations.compactMap { $0.topCandidates(1).first }
                let text = candidates.map { $0.string }.joined(separator: "\n")
                let language = NLLanguageRecognizer.dominantLanguage(for: text)?.rawValue
                continuation.resume(returning: (text, language))
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            if !languages.isEmpty {
                request.recognitionLanguages = languages
            }

            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: TextRecognitionError.recognitionFailed(error))
            }
        }
    }

    @MainActor
    private static func inputSourceLanguages() -> [String] {
        var languages = Set<String>()
        if let list = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
            for source in list {
                if let value = TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages) {
                    let array = Unmanaged<CFArray>.fromOpaque(value).takeUnretainedValue() as NSArray
                    for case let lang as String in array {
                        languages.insert(lang)
                    }
                }
            }
        }
        languages.formUnion(Locale.preferredLanguages)
        return Array(languages)
    }

    private static func printSupportedLanguages(for request: VNRecognizeTextRequest) {
        do {
            let supported = try request.supportedRecognitionLanguages()
            print("✅ Vision supports the following languages: \(supported)")
        } catch {
            print("❌ Could not get supported languages: \(error)")
        }
    }
}
