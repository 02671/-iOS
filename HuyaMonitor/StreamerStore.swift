import Foundation
import Combine

@MainActor
final class StreamerStore: ObservableObject {
    @Published private(set) var streamers: [Streamer] = [] {
        didSet { save() }
    }

    @Published var selectedStreamerID: UUID? {
        didSet { save() }
    }

    private let storageKey = "huya.monitor.followed.streamers.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([Streamer].self, from: data) {
            streamers = saved
            let savedSelection = UserDefaults.standard.string(forKey: storageKey + ".selected").flatMap { UUID(uuidString: $0) }
            selectedStreamerID = saved.first(where: { $0.id == savedSelection })?.id ?? saved.first?.id
        } else {
            streamers = []
            selectedStreamerID = nil
        }
    }

    var selectedStreamer: Streamer? {
        streamers.first { $0.id == selectedStreamerID }
    }

    func add(roomInput: String) throws {
        let roomID = try Self.extractRoomID(from: roomInput)
        guard !streamers.contains(where: { $0.roomID == roomID }) else {
            throw StreamerInputError.alreadyFollowed
        }

        let streamer = Streamer(roomID: roomID)
        streamers.append(streamer)
        selectedStreamerID = streamer.id
    }

    func remove(_ streamer: Streamer) {
        streamers.removeAll { $0.id == streamer.id }
        if selectedStreamerID == streamer.id {
            selectedStreamerID = streamers.first?.id
        }
    }

    func updateNotification(for streamer: Streamer, enabled: Bool) {
        guard let index = streamers.firstIndex(where: { $0.id == streamer.id }) else { return }
        streamers[index].notifyOnLive = enabled
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(streamers) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
        if let selectedStreamerID {
            UserDefaults.standard.set(selectedStreamerID.uuidString, forKey: storageKey + ".selected")
        } else {
            UserDefaults.standard.removeObject(forKey: storageKey + ".selected")
        }
    }

    private static func extractRoomID(from input: String) throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw StreamerInputError.invalidRoomID }

        var candidate = trimmed
        if trimmed.localizedCaseInsensitiveContains("huya.com") {
            let urlText = trimmed.contains("://") ? trimmed : "https://" + trimmed
            guard let url = URL(string: urlText) else { throw StreamerInputError.invalidRoomID }
            candidate = url.path.split(separator: "/").last.map(String.init) ?? ""
        }

        guard !candidate.isEmpty,
              candidate.count <= 16,
              candidate.allSatisfy({ $0.isNumber }) else {
            throw StreamerInputError.invalidRoomID
        }
        return candidate
    }
}
