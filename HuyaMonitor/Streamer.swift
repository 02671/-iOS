import Foundation

struct Streamer: Identifiable, Codable, Equatable {
    let id: UUID
    let roomID: String
    var name: String
    var notifyOnLive: Bool
    let addedAt: Date

    init(roomID: String, name: String? = nil) {
        self.id = UUID()
        self.roomID = roomID
        self.name = name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ? name!.trimmingCharacters(in: .whitespacesAndNewlines)
            : "房间 \(roomID)"
        self.notifyOnLive = true
        self.addedAt = Date()
    }
}

enum StreamerInputError: LocalizedError {
    case invalidRoomID
    case alreadyFollowed

    var errorDescription: String? {
        switch self {
        case .invalidRoomID:
            return "请输入有效的虎牙房间号，或粘贴虎牙直播间链接。"
        case .alreadyFollowed:
            return "这个房间已经在关注列表中了。"
        }
    }
}
