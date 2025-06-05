import SwiftUI
import Defaults

struct PromptsSettingsPane: View {
  @Default(.openAIPrompts) private var prompts
  @Default(.activePromptIndex) private var activePromptIndex

  var body: some View {
    VStack(alignment: .leading) {
      Picker("", selection: $activePromptIndex) {
        ForEach(prompts.indices, id: \.self) { index in
          Text(prompts[index])
            .fixedSize(horizontal: false, vertical: true)
            .tag(index)
        }
      }
      .pickerStyle(.radioGroup)
    }
    .frame(minWidth: 350, maxWidth: 450, minHeight: 300)
    .padding()
  }
}

#Preview {
  PromptsSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
