import SwiftUI

struct OnboardingAllSetView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("You're All Set!")
                .font(.title)
                .bold()
            
            VStack(spacing: 16) {
                Text("Here's what you can do next:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    TipRow(icon: "keyboard", text: "Press ⌘⇧C to open ClipVista")
                    TipRow(icon: "doc.on.clipboard", text: "Copy something to see it in your history")
                    TipRow(icon: "sparkles", text: "Try your custom prompts with your clipboard content")
                    TipRow(icon: "gear", text: "Customize settings in Preferences")
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
            
            Text("Need help? Visit our documentation or contact support")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

private struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
        }
    }
}

#Preview {
    OnboardingAllSetView()
} 