import SwiftUI

@Observable
class AddListViewModel {
    var title: String = ""
    var selectedColor: String = "Red"
    
    let colorOptions: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]
    
    func saveList() {
        print("리스트 저장됨: \(title), 색상: \(selectedColor)")
    }
}

struct AddListView: View {
    @Bindable var viewModel = AddListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                BackButton()
                    .padding(.trailing, 12)
                
                Text("새 리스트 생성")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            

            VStack(alignment: .leading, spacing: 15) {
                Text("이름")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))
                
                TextField(
                    text: $viewModel.title,
                    prompt: Text("새 리스트 명을 작성해주세요")
                        .font(.mainTextRegular14) // placeholder
                        .foregroundStyle(Color("gray-500")) // placeholder
                ) {
                    EmptyView() // onEditingChanged (필요하면 넣기)
                }
                .font(.mainTextRegular14)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("gray-200"), lineWidth: 1)
                )

            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            

            VStack(alignment: .leading, spacing: 12) {
                Text("색상 선택")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))
                
                HStack(spacing: 12) {
                    ForEach(viewModel.colorOptions, id: \.self) { color in
                        Button {
                            viewModel.selectedColor = color
                        } label: {
                            Image("Place\(color)")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.selectedColor == color ? Color("blue-500") : .clear, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            
            Spacer()
            
            Button {
                viewModel.saveList()
            } label: {
                Text("저장")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color("darkblue-500"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)

        }
    }
}

#Preview {
    AddListView().withRouter()
}
