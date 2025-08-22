//
//import SwiftUI
//
//struct SavePlaceSheetView: View {
//    let zoneId: Int
//    let zoneName: String
//   
//
//    @Bindable var vm: UserPlaceViewModel   // DI
//
//    @Environment(\.dismiss) private var dismiss
//    
//  
//
//    @State private var selectedIDs: Set<Int> = []
//
//    var body: some View {
//        
//        let items: [SimpleSavedPlaceResponse] = vm.places
//        
//        VStack(alignment: .leading) {
//            Capsule()
//                .frame(width: 98, height: 6)
//                .foregroundStyle(Color("gray-300"))
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 14)
//
//            Text(zoneName)
//                .font(.mainTextSemibold24)
//                .foregroundStyle(Color("gray-900"))
//                .padding(.top, 6)
//                .padding(.horizontal, 20)
//
//            List(items) { place in
//                    Button {
//                        toggleSelection(id: place.placeId)
//                    } label: {
//                        HStack(spacing: 11) {
//                            Image("Place\(place.color)")
//                                .resizable()
//                                .frame(width: 36, height: 36)
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 5) {
//                                Text(place.title)
//                                    .font(.mainTextSemibold14)
//                                    .foregroundStyle(Color("gray-900"))
//                                Text("저장 장소 \(place.savedCount)")
//                                    .font(.mainTextRegular12)
//                                    .foregroundStyle(Color("gray-700"))
//                            }
//
//                            Spacer()
//
//                            Image(selectedIDs.contains(place.placeId) ? "check05" : "check01")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                        }
//                    }
//                    .disabled(vm.isSaving)
////                }
////                .listRowSeparator(.hidden)
//            }
//            .listStyle(.plain)
//            .padding(.bottom, 16)
//
//            Button {
//                Task { await saveSelections() }
//            } label: {
//                Text(vm.isSaving ? "저장 중..." : "저장")
//                    .font(.mainTextSemibold16)
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background((selectedIDs.isEmpty || vm.isSaving) ? Color("gray-300") : Color("darkblue-700"))
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 30)
//            }
//            .disabled(selectedIDs.isEmpty || vm.isSaving)
//        }
//        .background(Color.white)
//        .clipShape(RoundedRectangle(cornerRadius: 24))
//        .ignoresSafeArea(.all, edges: .bottom)
//        .task {
//                    if vm.places.isEmpty {
//                        await vm.fetch(sort: .latest)
//                    }
//                }
////        .onChange(of: vm.successMessage) { _, new in
////            if new != nil { dismiss() }
////        }
////        .alert("오류", isPresented: .constant(vm.errorMessage != nil)) {
////            Button("확인", role: .cancel) { vm.errorMessage = nil }
////        } message: {
////            Text(vm.errorMessage ?? "")
////        }
//    }
//
//    private func toggleSelection(id: Int) {
//        if selectedIDs.contains(id) { selectedIDs.remove(id) }
//        else { selectedIDs.insert(id) }
//    }
//
//    private func saveSelections() async {
//        await vm.PlaceSave(placeIds: Array(selectedIDs), waybleZoneId: zoneId)
//    }
//}
import SwiftUI

struct SavePlaceSheetView: View {
    let zoneId: Int
    let zoneName: String


    @Binding var isPresented: Bool

    @Binding var selectedIndex: Int

    @Bindable var vm: UserPlaceViewModel

    @State private var showModal = false
    @State private var selectedIDs: Set<Int> = []

    var body: some View {
        
        let items: [SimpleSavedPlaceResponse] = vm.places

        ZStack {

            VStack(alignment: .leading) {
                Capsule()
                    .frame(width: 98, height: 6)
                    .foregroundStyle(Color("gray-300"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)

                Text(zoneName)
                    .font(.mainTextSemibold24)
                    .foregroundStyle(Color("gray-900"))
                    .padding(.top, 6)
                    .padding(.horizontal, 20)

                List(items) { place in
                    Button {
                        toggleSelection(id: place.placeId)
                    } label: {
                        HStack(spacing: 11) {
                            Image("Place\(place.color)")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 5) {
                                Text(place.title)
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color("gray-900"))
                                Text("저장 장소 \(place.savedCount)")
                                    .font(.mainTextRegular12)
                                    .foregroundStyle(Color("gray-700"))
                            }

                            Spacer()

                            Image(selectedIDs.contains(place.placeId) ? "check05" : "check01")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .disabled(vm.isSaving)
                }
                .listStyle(.plain)
                .padding(.bottom, 16)

                Button {
                    Task { await saveSelections() }
                } label: {
                    Text(vm.isSaving ? "저장 중..." : "저장")
                        .font(.mainTextSemibold16)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((selectedIDs.isEmpty || vm.isSaving) ? Color("gray-300") : Color("darkblue-700"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
                .disabled(selectedIDs.isEmpty || vm.isSaving)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .ignoresSafeArea(.all, edges: .bottom)
            .task {
                if vm.places.isEmpty {
                    await vm.fetch(sort: .latest)
                }
            }


            .onChange(of: vm.successMessage) { _, msg in
                guard msg != nil else { return }
                withAnimation { showModal = true }
            }

            .alert(
                "오류",
                isPresented: Binding(
                    get: { vm.errorMessage != nil },
                    set: { _ in vm.errorMessage = nil }
                )
            ) {
                Button("확인", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }

 
            if showModal {
                Color("black").opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showModal = false } }

                WaybleZoneModal(
                    title: "리스트에 저장했어요!",
                    buttonText: "확인",
                    onButtonTap: {
                        withAnimation { showModal = false }
                
                        isPresented = false

                        selectedIndex = 4
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }

    private func toggleSelection(id: Int) {
        if selectedIDs.contains(id) { selectedIDs.remove(id) }
        else { selectedIDs.insert(id) }
    }

    private func saveSelections() async {
        await vm.PlaceSave(placeIds: Array(selectedIDs), waybleZoneId: zoneId)
    }
}
