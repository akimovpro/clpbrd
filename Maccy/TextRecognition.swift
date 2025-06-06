import AppKit
import Carbon
import Vision

enum TextRecognitionError: Error {
    case invalidImage
    case recognitionFailed(Error)
}

struct TextRecognition {
    
    /// Recognizes text in the given image data.
    /// - Parameter imageData: The Data of the image to process.
    /// - Returns: The recognized text as a String.
    /// - Throws: A `TextRecognitionError` if the image is invalid or recognition fails.
    static func recognize(imageData: Data) async throws -> String {
        guard let image = NSImage(data: imageData),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw TextRecognitionError.invalidImage
        }

        // 1. Get the user's configured keyboard input languages.
        let inputLanguages = await inputSourceLanguages()
        
        // 2. Create a set of languages for recognition.
        // We include English ("en-US") and Russian ("ru-RU") as strong defaults,
        // plus any other languages from the user's system.
        // A Set automatically handles duplicates.
        var potentialLanguages = Set(inputLanguages)
        potentialLanguages.insert("en-US")
        potentialLanguages.insert("ru-RU")

        // 3. Perform a single, accurate recognition request.
        let recognizedText = try await performRecognition(on: cgImage, withLanguages: Array(potentialLanguages))
        return recognizedText
    }

    /// Performs the actual Vision text recognition.
    private static func performRecognition(on cgImage: CGImage, withLanguages languages: [String]) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: TextRecognitionError.recognitionFailed(error))
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }

                let recognizedStrings = observations.compactMap { observation in
                    // Return the most confident recognition candidate.
                    observation.topCandidates(1).first?.string
                }

                continuation.resume(returning: recognizedStrings.joined(separator: "\n"))
            }

            // KEY FIX 1: Use .accurate for better language support, including Cyrillic.
            request.recognitionLevel = .accurate
            
            // KEY FIX 2: Provide the list of potential languages to the request.
            // Vision uses this list to improve accuracy.
            request.recognitionLanguages = languages
            
            // Optional: You can uncomment this to check if your OS version supports the languages.
            // printSupportedLanguages(for: request)

            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: TextRecognitionError.recognitionFailed(error))
            }
        }
    }

    /// Retrieves the user's enabled keyboard input source languages (e.g., "en", "ru").
    @MainActor
    private static func inputSourceLanguages() -> [String] {
        guard let list = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource],
              let sources = list as? [TISInputSource] else { return [] }
        
        var languages = Set<String>()
        for source in sources {
            // We want languages associated with this input source (keyboard)
            guard let pointer = TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages) else { continue }
            let langArray = Unmanaged<CFArray>.fromOpaque(pointer).takeUnretainedValue() as? [String]
            
            if let langArray = langArray {
                languages.formUnion(langArray)
            }
        }
        return Array(languages)
    }
    
    /// A helper utility to print which languages are actually supported on the current device.
    private static func printSupportedLanguages(for request: VNRecognizeTextRequest) {
        do {
            let supported = try request.supportedRecognitionLanguages()
            print("✅ Vision supports the following languages: \(supported)")
        } catch {
            print("❌ Could not get supported languages: \(error)")
        }
    }
}
