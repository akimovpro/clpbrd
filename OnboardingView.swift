import SwiftUI
import Defaults

// MARK: - Main Onboarding View

struct OnboardingView: View {
  /// Presentation binding supplied by the caller
  @Binding var isPresented: Bool

  /// Current step in the onboarding flow
  @State private var step: OnboardingStep = .welcome

  /// Collected user-input
  @State private var role: String = "Designer"
  @State private var dayToDayText: String = ""

  /// Async prompt-generation state
  @State private var generatingPrompts = false

  /// Flow steps (ordered by raw value)
  enum OnboardingStep: Int, CaseIterable, Comparable {
    case welcome = 1, features, aboutYou, prompts, pricing, allSet
    static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
  }

  // MARK: View tree
  var body: some View {
    VStack(spacing: 0) {

      // Progress indicator
      VStack {
        ProgressView(value: Double(step.rawValue),
                     total: Double(OnboardingStep.allCases.count))
        HStack {
          Text("Step \(step.rawValue) of \(OnboardingStep.allCases.count)")
            .font(.caption)
            .foregroundColor(.secondary)
          Spacer()
          Text("\(Int((Double(step.rawValue) / Double(OnboardingStep.allCases.count)) * 100))% complete")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      .padding([.horizontal, .top])

      // Step-specific content
      VStack {
        switch step {
        case .welcome:   OnboardingWelcomeView()
        case .features:  OnboardingFeaturesView()
        case .aboutYou:  OnboardingAboutYouView(role: $role, dayToDay: $dayToDayText)
        case .prompts:   OnboardingPromptsView(role: role, generating: $generatingPrompts)
        case .pricing:
          SubscriptionView(
            isPresented: $isPresented,
            fromOnboarding: true,
            onContinue:  { step = .allSet },
            onDecideLater: { step = .allSet }
          )
        case .allSet:    OnboardingAllSetView()
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(40)

      // Navigation buttons
      HStack {
        if step > .welcome {
          Button {
            if let prev = OnboardingStep(rawValue: step.rawValue - 1) { step = prev }
          } label: {
            Image(systemName: "arrow.left")
            Text("Back")
          }
          .buttonStyle(.plain)
        }
        Spacer()
        if step == .pricing {
          Button { step = .allSet } label: {
            Text("I'll decide later")
            Image(systemName: "arrow.right")
          }
          .keyboardShortcut(.rightArrow)
        } else {
          Button(action: handleContinue) {
            Text(continueButtonText)
            if step < .allSet { Image(systemName: "arrow.right") }
          }
          .buttonStyle(.borderedProminent)
          .disabled(continueButtonDisabled)
          .keyboardShortcut(.defaultAction)
        }
      }
      .padding()
    }
    .frame(width: 800, height: 650)
    .onDisappear { Defaults[.onboardingCompleted] = true }
  }

  // MARK: Helpers
  private var continueButtonText: String {
    switch step {
    case .welcome:   return "Let's Get Started"
    case .aboutYou:  return "Generate My Prompts"
    case .allSet:    return "Start Using ClipVista"
    default:         return "Continue"
    }
  }

  private var continueButtonDisabled: Bool {
    switch step {
    case .aboutYou: return dayToDayText.count < 50
    case .prompts:  return generatingPrompts
    default:        return false
    }
  }

  private func handleContinue() {
    if step == .allSet { isPresented = false; return }
    if step == .aboutYou { generatingPrompts = true }
    if let next = OnboardingStep(rawValue: step.rawValue + 1) { step = next }
  }
}

// MARK: - Step Views

struct OnboardingWelcomeView: View {
  var body: some View {
    VStack(spacing: 20) {
      Spacer()
      Image(nsImage: NSApp.applicationIconImage)
        .resizable()
        .frame(width: 80, height: 80)
        .padding(.bottom)
      Text("Welcome to ClipVista")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("The AI-powered clipboard manager that transforms how you work with text. Copy, enhance, and reuse content like never before.")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      HStack(spacing: 20) {
        FeatureCard(icon: "doc.on.clipboard.fill", title: "Smart Clipboard", description: "Automatically captures and organizes everything you copy")
        FeatureCard(icon: "sparkles", title: "AI Enhancement", description: "Transform any text with powerful AI processing")
        FeatureCard(icon: "bolt.fill", title: "Instant Access", description: "Quick shortcuts and seamless workflow integration")
      }
      .padding(.top)
      Spacer()
      Text("Takes less than 2 minutes to set up")
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
}

struct OnboardingFeaturesView: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Powerful Features for Every Workflow")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("ClipVista isn't just a clipboard manager—it's your AI-powered productivity companion")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      VStack(spacing: 15) {
        HStack(spacing: 15) {
          FeatureTile(icon: "clock.arrow.circlepath", title: "Infinite History", description: "Never lose copied text again. Access your complete clipboard history with smart search.")
          FeatureTile(icon: "brain.head.profile", title: "AI Processing", description: "Transform text with AI. Summarize, translate, rewrite, or enhance any content instantly.")
          FeatureTile(icon: "lightbulb.fill", title: "Smart Suggestions", description: "Get intelligent recommendations for improving your text based on context and purpose.")
        }
        HStack(spacing: 15) {
          FeatureTile(icon: "square.and.arrow.up.on.square.fill", title: "Quick Actions", description: "Custom shortcuts and automation for your most common text transformations.")
          FeatureTile(icon: "lock.shield.fill", title: "Privacy First", description: "Your data stays local. End-to-end encryption for sensitive information.")
          FeatureTile(icon: "bolt.fill", title: "Lightning Fast", description: "Instant access with global shortcuts. Integrate seamlessly into any workflow.")
        }
      }
    }
  }
}

struct OnboardingAboutYouView: View {
  @Binding var role: String
  @Binding var dayToDay: String
  private let roles = ["Developer", "Content Creator", "Business Professional", "Researcher", "Designer", "Other"]

  var body: some View {
    VStack(spacing: 20) {
      Text("Tell Us About Yourself")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("We'll customize ClipVista to match your workflow and generate personalized AI prompts")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      VStack(alignment: .leading, spacing: 15) {
        Text("What's your primary role?").font(.headline)
        HStack {
          ForEach(roles.prefix(3), id: \.self) { roleName in
            RoleButton(title: roleName, icon: roleIcon(roleName), selectedRole: $role)
          }
        }
        HStack {
          ForEach(roles.suffix(3), id: \.self) { roleName in
            RoleButton(title: roleName, icon: roleIcon(roleName), selectedRole: $role)
          }
        }

        Text("What do you do day-to-day? *").font(.headline).padding(.top)
        TextEditor(text: $dayToDay)
          .frame(height: 100)
          .border(Color.secondary.opacity(0.5), width: 1)
          .cornerRadius(5)
        HStack {
          Spacer()
          Text("The more specific you are, the better we can customize your experience. \(dayToDay.count)/50 minimum characters")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
  }

  private func roleIcon(_ role: String) -> String {
    switch role {
    case "Developer": return "chevron.left.forward.slash.chevron.right"
    case "Content Creator": return "pencil.and.outline"
    case "Business Professional": return "briefcase.fill"
    case "Researcher": return "books.vertical.fill"
    case "Designer": return "heart.fill"
    case "Other": return "ellipsis.circle.fill"
    default: return "questionmark"
    }
  }
}

struct OnboardingPromptsView: View {
  var role: String
  @Binding var generating: Bool

  private let prompts: [String: [String]] = [
    "Designer": [
      "Convert this creative brief into user personas",
      "Transform this feedback into actionable design changes",
      "Create a design rationale from this concept",
      "Rewrite this design critique constructively",
      "Generate user scenarios from this project brief",
      "Convert this style guide into implementation notes",
      "Transform this client feedback into design requirements",
      "Create accessibility descriptions for this visual content",
      "Generate design principles from this brand guideline",
      "Convert this usability report into design recommendations"
    ]
  ]

  var body: some View {
    VStack(spacing: 20) {
      Text("Your Personalized AI Prompts")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("Based on your role as a \(role), here are custom prompts to supercharge your workflow")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      if generating {
        Spacer()
        ProgressView()
          .progressViewStyle(.circular)
          .scaleEffect(1.5)
        Text("Generating your custom prompts...")
          .font(.title3)
          .padding(.top)
        Text("Our AI is analyzing your role and creating personalized prompts")
          .foregroundColor(.secondary)
        Spacer()
      } else {
        VStack(alignment: .leading) {
          Text("Your Custom Prompts (10 generated)").font(.headline)
          ScrollView {
            VStack(spacing: 10) {
              ForEach(Array((prompts[role] ?? prompts["Designer"]!).enumerated()), id: \.offset) { index, prompt in
                PromptTile(prompt: prompt, index: index + 1)
              }
            }
          }
          .padding(.vertical)

          HStack {
            Image(systemName: "lightbulb.fill")
              .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
              Text("Pro tip:").fontWeight(.bold)
              Text("These prompts are saved to your ClipVista account. You can access them anytime and create your own custom prompts as you discover new workflows.")
            }
          }
          .padding()
          .background(Color.secondary.opacity(0.1))
          .cornerRadius(10)
        }
      }
    }
    .onAppear {
      if generating {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          generating = false
        }
      }
    }
  }
}

struct OnboardingAllSetView: View {
  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 60))
        .foregroundColor(.green)
      Text("You're All Set!")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("ClipVista is ready to supercharge your productivity. Start copying text and watch the magic happen!")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      HStack(spacing: 20) {
        FeatureCard(icon: "bolt.fill", title: "Use ⌘+Shift+V", description: "Quick access to your clipboard history")
        FeatureCard(icon: "wand.and.stars", title: "AI Magic", description: "Right-click any text to enhance it with AI")
        FeatureCard(icon: "tag.fill", title: "Stay Organized", description: "Use tags and favorites to organize your clips")
      }
      .padding()

      VStack(alignment: .leading) {
        Text("What's Next?").font(.headline)
        Text("Start using ClipVista in your daily workflow. Copy some text, try your custom prompts, and discover how AI can transform the way you work with content.")
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.secondary.opacity(0.1))
      .cornerRadius(10)

      Text("Need help? Press ⌘+? anytime for quick tips and shortcuts")
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
}

// MARK: - Helper Views

struct FeatureCard: View {
    var icon: String
    var title: String
    var description: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(height: 30)
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(minHeight: 150)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RoleButton: View {
  var title: String
  var icon: String
  @Binding var selectedRole: String

  var isSelected: Bool { title == selectedRole }

  var body: some View {
    Button(action: { selectedRole = title }) {
      VStack(alignment: .leading, spacing: 5) {
        Image(systemName: icon)
        Text(title)
      }
      .padding()
      .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
      .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.1))
      .foregroundColor(isSelected ? .white : .primary)
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(.plain)
  }
}

struct PromptTile: View {
  var prompt: String
  var index: Int

  var body: some View {
    HStack {
      Text("Prompt \(index)")
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.accentColor.opacity(0.2))
        .cornerRadius(10)
      Text(prompt)
      Spacer()
    }
    .padding()
    .background(Color.secondary.opacity(0.1))
    .cornerRadius(10)
  }
} 