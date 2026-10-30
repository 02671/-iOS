import Foundation
import UserNotifications

enum NotificationManager {
    static func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    @discardableResult
    static func requestPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    }

    static func scheduleLocalTestNotification() async throws {
        let content = UNMutableNotificationContent()
        content.title = "虎牙监控测试通知"
        content.body = "iPhone 本机通知功能正常。主播开播远程推送尚未接入。"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(
            identifier: "huya-monitor-local-test-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        try await UNUserNotificationCenter.current().add(request)
    }
}
