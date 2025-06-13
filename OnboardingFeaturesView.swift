import SwiftUI

struct OnboardingFeaturesView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("Key Features")
                .font(.title)
                .bold()
            
            ScrollView {
                VStack(spacing: 24) {
                    FeatureCard(
                        title: "Smart Clipboard",
                        description: "Store and organize your clipboard history with intelligent categorization",
                        icon: "doc.on.clipboard.fill"
                    )
                    
                    FeatureCard(
                        title: "AI-Powered Prompts",
                        description: "Generate context-aware prompts from your clipboard content",
                        icon: "sparkles.rectangle.stack.fill"
                    )
                    
                    FeatureCard(
                        title: "Quick Access",
                        description: "Access your clipboard history and AI features with a simple keyboard shortcut",
                        icon: "keyboard.fill"
                    )
                    
                    FeatureCard(
                        title: "Customization",
                        description: "Tailor the app to your workflow with customizable settings",
                        icon: "slider.horizontal.3"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct FeatureCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    OnboardingFeaturesView()
} 