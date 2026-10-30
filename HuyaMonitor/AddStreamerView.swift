import SwiftUI

struct AddStreamerView: View {
    @EnvironmentObject private var store: StreamerStore
    @Environment(\.dismiss) private var dismiss
    @State private var roomInput = ""
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("虎牙直播间") {
                TextField("输入房间号或粘贴直播间链接", text: $roomInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)

                Text("例如：123456，或 https://www.huya.com/123456")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Text("添加后会保存在本机关注列表。真实主播名称、开播状态和开播推送将在虎牙数据接口接通后启用。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("添加主播")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("添加") {
                    do {
                        try store.add(roomInput: roomInput)
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
                .disabled(roomInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .alert("无法添加主播", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("确定", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}
