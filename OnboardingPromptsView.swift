import SwiftUI

struct OnboardingPromptsView: View {
    let role: String
    @Binding var generating: Bool
    
    @State private var prompts: [String] = []
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Your Custom Prompts")
                .font(.title)
                .bold()
            
            if generating {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Generating your custom prompts...")
                        .foregroundColor(.secondary)
                }
            } else if prompts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                    Text("No prompts generated yet")
                        .foregroundColor(.secondary)
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(prompts, id: \.self) { prompt in
                            PromptCard(prompt: prompt)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Text("These prompts will help you get the most out of ClipVista")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onAppear {
            generatePrompts()
        }
    }
    
    private func generatePrompts() {
        // Simulate API call to generate prompts
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            prompts = [
                "Generate a design brief based on my clipboard content",
                "Create a code review checklist from my copied code",
                "Summarize the key points from my copied text",
                "Suggest improvements for my copied content"
            ]
            generating = false
        }
    }
}

private struct PromptCard: View {
    let prompt: String
    
    var body: some View {
        HStack {
            Text(prompt)
                .font(.body)
            Spacer()
            Button {
                // Copy to clipboard
            } label: {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    OnboardingPromptsView(
        role: "Designer",
        generating: .constant(false)
    )
} 