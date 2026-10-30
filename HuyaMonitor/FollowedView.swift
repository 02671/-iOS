import SwiftUI

struct FollowedView: View {
    @EnvironmentObject private var store: StreamerStore
    @State private var showingAddStreamer = false

    var body: some View {
        Group {
            if store.streamers.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 42))
                        .foregroundStyle(.secondary)
                    Text("还没有关注主播")
                        .font(.headline)
                    Text("点击右上角添加房间号，建立你的主播列表。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button {
                        showingAddStreamer = true
                    } label: {
                        Label("添加主播", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .padding(32)
            } else {
                List {
                    ForEach(store.streamers) { streamer in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(streamer.name)
                                        .font(.headline)
                                    Text("房间号：\(streamer.roomID)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("待接入")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(.orange)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(.orange.opacity(0.12), in: Capsule())
                            }

                            Toggle(isOn: Binding(
                                get: { streamer.notifyOnLive },
                                set: { store.updateNotification(for: streamer, enabled: $0) }
                            )) {
                                Label("主播开播提醒", systemImage: "bell")
                                    .font(.subheadline)
                            }
                            .tint(.red)
                        }
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.selectedStreamerID = streamer.id
                        }
                    }
                    .onDelete { offsets in
                        let removed = offsets.map { store.streamers[$0] }
                        removed.forEach(store.remove)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("关注主播")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddStreamer = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("添加主播")
            }
        }
        .sheet(isPresented: $showingAddStreamer) {
            NavigationStack {
                AddStreamerView()
            }
        }
    }
}
