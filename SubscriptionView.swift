import SwiftUI
import Defaults

struct SubscriptionView: View {
  @Binding var isPresented: Bool
  var fromOnboarding: Bool
  var onContinue: (() -> Void)?
  var onDecideLater: (() -> Void)?

  var body: some View {
    VStack(spacing: 20) {
      Text("Unlock ClipVista Premium")
        .font(.largeTitle)
        .fontWeight(.bold)
      Text("Get the most out of your AI clipboard with unlimited features and premium support")
        .font(.title2)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding(.horizontal)

      HStack(spacing: 20) {
        PricingCard(
          title: "Free",
          price: "$0",
          description: "Perfect for getting started",
          features: [
            "Store up to 100 clipboard items",
            "Basic text transformations",
            "5 AI requests per day",
            "Simple search functionality"
          ],
          buttonText: "Continue with Free",
          isRecommended: false,
          action: {
            onDecideLater?()
          }
        )
        PricingCard(
          title: "Premium",
          price: "$9.99",
          pricePeriod: "per month",
          description: "For power users and professionals",
          features: [
            "Unlimited clipboard history", "Advanced AI transformations", "Unlimited AI requests",
            "Smart categorization & tagging", "Custom prompt creation", "Team collaboration features",
            "Priority customer support", "Advanced security & encryption"
          ],
          buttonText: "Start Premium Trial",
          isRecommended: true,
          action: {
            onContinue?()
          }
        )
      }

      HStack(spacing: 20) {
        FeatureTile(icon: "infinity", title: "Unlimited Everything", description: "No limits on storage or AI usage")
        FeatureTile(icon: "brain.head.profile", title: "Advanced AI", description: "Latest models and capabilities")
        FeatureTile(icon: "bolt.fill", title: "Lightning Fast", description: "Priority processing and support")
        FeatureTile(icon: "shield.lefthalf.filled", title: "Enterprise Security", description: "Advanced encryption and privacy")
      }
    }
  }
}

struct SubscriptionButtonStyle: ButtonStyle {
    var isProminent: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isProminent ? Color.accentColor : Color.clear)
            .foregroundColor(isProminent ? .white : .primary)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isProminent ? Color.accentColor : Color.secondary, lineWidth: 1)
            )
    }
}

struct PricingCard: View {
  var title: String
  var price: String
  var pricePeriod: String?
  var description: String
  var features: [String]
  var buttonText: String
  var isRecommended: Bool
  var action: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      HStack {
        if isRecommended {
          Image(systemName: "crown.fill").foregroundColor(.orange)
        }
        Text(title).font(.title).fontWeight(.bold)
        Spacer()
        if isRecommended {
          Text("RECOMMENDED")
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(5)
        }
      }
      HStack(alignment: .bottom, spacing: 2) {
        Text(price).font(.largeTitle).fontWeight(.bold)
        if let period = pricePeriod {
          Text(period).foregroundColor(.secondary).padding(.bottom, 4)
        }
      }
      if isRecommended {
        Text("Save 20% with annual billing").font(.caption).foregroundColor(.green)
      }
      Text(description).foregroundColor(.secondary)

      VStack(alignment: .leading, spacing: 8) {
        ForEach(features, id: \.self) { feature in
          Label(feature, systemImage: "checkmark").foregroundColor(.primary)
        }
      }
      .padding(.top)

      Spacer()

      Button(action: action) {
        Text(buttonText)
          .frame(maxWidth: .infinity)
      }
      .controlSize(.large)
      .buttonStyle(SubscriptionButtonStyle(isProminent: isRecommended))

      if isRecommended {
        Text("14-day free trial · Cancel anytime · No hidden fees")
          .font(.caption)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity)
      }
    }
    .padding()
    .background(Color.secondary.opacity(0.1))
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(isRecommended ? Color.accentColor : Color.clear, lineWidth: 2)
    )
  }
}

struct FeatureTile: View {
    var icon: String
    var title: String
    var description: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(description).foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct PaymentView: View {
  var plan: String
  var onDone: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      Text("Stripe Payment")
        .font(.largeTitle)
      Text("This is a placeholder for Stripe integration for the \(plan) plan.")
        .multilineTextAlignment(.center)
      ProgressView()
      Button("Simulate Successful Payment") {
        Defaults[.isSubscribed] = true
        onDone()
      }
      .controlSize(.large)
      Button("Cancel", action: onDone)
    }
    .padding(40)
    .frame(width: 500, height: 600)
  }
} 