import SwiftUI
struct ReviewTextEditorView: View {
    @Binding var reviewText: String
    let maxCharacters: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("후기글 작성")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-900"))

            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    TextEditor(text: $reviewText)
                        .frame(height: 102)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .onChange(of: reviewText) { _, newValue in
                            if newValue.count > maxCharacters {
                                reviewText = String(newValue.prefix(maxCharacters))
                            }
                        }

                    HStack {
                        Spacer()
                        Text("\(reviewText.count)/\(maxCharacters)")
                            .font(.mainTextSemibold10)
                            .foregroundStyle(Color("gray-700"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                    }
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("gray-300"), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if reviewText.isEmpty {
                    Text("소중한 후기를 남겨주세요")
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color("gray-700"))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }
            }
        }.padding(.horizontal,20)
    }
}


struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

#Preview {
    StatefulPreviewWrapper("") { binding in
        ReviewTextEditorView(reviewText: binding, maxCharacters: 1000)
    }
}
