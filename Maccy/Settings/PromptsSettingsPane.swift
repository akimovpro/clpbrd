import SwiftUI
import Defaults

struct PromptsSettingsPane: View {
  @Default(.openAIPrompts) private var prompts
  @Default(.activePromptIndex) private var activePromptIndex

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Picker("", selection: $activePromptIndex) {
        ForEach(prompts.indices, id: \.self) { index in
          HStack(alignment: .top) {
            TextEditor(
              text: Binding(
                get: { prompts[index] },
                set: { prompts[index] = $0 }
              )
            )
            .lineLimit(4)
            .frame(minHeight: 60)
          }
          .tag(index)
        }
      }
      .pickerStyle(.radioGroup)

      Text("ShortcutsInfo", tableName: "PromptsSettings")
        .foregroundStyle(.gray)
        .controlSize(.small)
    }
    .frame(minWidth: 500, maxWidth: 600, minHeight: 400)
    .padding()
  }
}

#Preview {
  PromptsSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
