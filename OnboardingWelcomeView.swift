import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "clipboard.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("Welcome to ClipVista")
                .font(.largeTitle)
                .bold()
            
            Text("Your AI-powered clipboard companion")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "wand.and.stars", text: "Generate AI prompts from your clipboard content")
                FeatureRow(icon: "sparkles", text: "Enhance your productivity with smart suggestions")
                FeatureRow(icon: "bolt.fill", text: "Lightning-fast access to your clipboard history")
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .font(.title3)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    OnboardingWelcomeView()
} 