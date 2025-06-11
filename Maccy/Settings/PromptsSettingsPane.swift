import SwiftUI
import Defaults

struct PromptsSettingsPane: View {
  @Default(.openAIPrompts) private var prompts
  @Default(.activePromptIndex) private var activePromptIndex

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      List {
        ForEach(prompts.indices, id: \.self) { index in
          HStack(alignment: .top) {
            Button {
              activePromptIndex = index
            } label: {
              Image(systemName: activePromptIndex == index ? "largecircle.fill.circle" : "circle")
            }
            .buttonStyle(.plain)
            .padding(.top, 8)

            TextEditor(text: $prompts[index])
              .lineLimit(4)
              .frame(minHeight: 60)
          }
          .padding(.vertical, 5)
        }
      }

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
