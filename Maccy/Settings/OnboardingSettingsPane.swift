import SwiftUI
import Defaults
import Settings

struct OnboardingSettingsPane: View {
    @State private var showOnboarding = false
    
    var body: some View {
        Settings.Container(contentWidth: 650) {
            Settings.Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Want to see the onboarding again?")
                        .font(.headline)
                    
                    Text("You can restart the onboarding process to learn more about ClipVista's features and set up your preferences.")
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        Defaults[.onboardingCompleted] = false
                        showOnboarding = true
                    }) {
                        Text("Restart Onboarding")
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
}

#Preview {
    OnboardingSettingsPane()
} 