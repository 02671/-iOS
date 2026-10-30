import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @State private var resultMessage = ""
    @State private var showingResult = false
    @State private var isWorking = false

    private var canSendTest: Bool {
        authorizationStatus == .authorized ||
        authorizationStatus == .provisional ||
        authorizationStatus == .ephemeral
    }

    var body: some View {
        Form {
            Section("通知权限") {
                HStack {
                    Label("iPhone 通知权限", systemImage: "bell.badge")
                    Spacer()
                    Text(statusDescription)
                        .foregroundStyle(statusColor)
                }

                Button {
                    Task {
                        isWorking = true
                        defer { isWorking = false }
                        do {
                            _ = try await NotificationManager.requestPermission()
                            await refreshStatus()
                        } catch {
                            showResult("申请通知权限失败：\(error.localizedDescription)")
                        }
                    }
                } label: {
                    Label("申请 / 检查通知权限", systemImage: "checkmark.shield")
                }
                .disabled(isWorking)

                Button {
                    Task {
                        do {
                            try await NotificationManager.scheduleLocalTestNotification()
                            showResult("已安排本机测试通知。请等待约 5 秒；这只是 iPhone 本地通知测试，不代表主播开播远程推送已经接通。")
                        } catch {
                            showResult("安排测试通知失败：\(error.localizedDescription)")
                        }
                    }
                } label: {
                    Label("发送本机测试通知（约 5 秒后）", systemImage: "paperplane")
                }
                .disabled(!canSendTest)
            }

            Section("关于监控") {
                LabeledContent("软件用途", value: "个人虎牙直播监控")
                LabeledContent("当前版本", value: "0.1.0 · 基础界面")
                LabeledContent("最低系统", value: "iOS 17")
                Text("主播开播远程推送需要云端服务和 Apple APNs 配置；虎牙弹幕、直播状态和音频也需要接通可持续使用的数据来源。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("隐私与安全") {
                Text("关注列表目前只保存在这台 iPhone 上。不要把虎牙账号密码、Apple 推送私钥或访问令牌发送给任何人，也不要提交到公开仓库。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("设置")
        .task {
            await refreshStatus()
        }
        .alert("通知设置", isPresented: $showingResult) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(resultMessage)
        }
    }

    private var statusDescription: String {
        switch authorizationStatus {
        case .notDetermined: return "尚未询问"
        case .denied: return "已拒绝"
        case .authorized: return "已允许"
        case .provisional: return "临时允许"
        case .ephemeral: return "临时授权"
        @unknown default: return "未知"
        }
    }

    private var statusColor: Color {
        canSendTest ? .green : .secondary
    }

    @MainActor
    private func refreshStatus() async {
        authorizationStatus = await NotificationManager.authorizationStatus()
    }

    @MainActor
    private func showResult(_ message: String) {
        resultMessage = message
        showingResult = true
    }
}
