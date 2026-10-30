import SwiftUI

struct MonitorView: View {
    @EnvironmentObject private var store: StreamerStore
    @State private var showingAddStreamer = false
    @State private var showingIntegrationInfo = false

    private var currentStreamer: Streamer? {
        store.selectedStreamer
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("虎牙监控")
                            .font(.largeTitle.bold())
                        Text("关注主播 · 弹幕 · 直播声音")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Label("数据源待接入", systemImage: "exclamationmark.circle")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(.orange.opacity(0.12), in: Capsule())
                }

                streamerPicker

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("直播状态")
                            .font(.headline)
                        Spacer()
                        Text("尚未连接")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.orange)
                    }

                    if let streamer = currentStreamer {
                        Text(streamer.name)
                            .font(.title3.bold())
                        Text("房间号：\(streamer.roomID)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("还没有关注主播")
                            .font(.title3.bold())
                        Text("先添加一个虎牙房间号，就可以建立你的关注列表。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        showingIntegrationInfo = true
                    } label: {
                        Label("启动监控", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(currentStreamer == nil)
                }
                .padding(16)
                .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("实时弹幕")
                            .font(.headline)
                        Spacer()
                        Text("等待数据接入")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 10) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 30))
                            .foregroundStyle(.secondary)
                        Text("虎牙弹幕接入后会显示在这里")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("当前不会显示模拟或伪造弹幕")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 145)
                    .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("直播声音")
                            .font(.headline)
                        Spacer()
                        Label("尚未接入", systemImage: "waveform.slash")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("取得可用的直播音频地址并完成接入后，这里就可以播放直播声音。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddStreamer) {
            NavigationStack {
                AddStreamerView()
            }
        }
        .alert("虎牙数据源尚未接入", isPresented: $showingIntegrationInfo) {
            Button("知道了", role: .cancel) { }
        } message: {
            Text("当前版本已经可以管理本地关注列表和测试 iPhone 通知。真实开播检测、弹幕和直播音频需要先接通可用的虎牙数据来源。")
        }
    }

    private var streamerPicker: some View {
        HStack(spacing: 10) {
            Menu {
                ForEach(store.streamers) { streamer in
                    Button {
                        store.selectedStreamerID = streamer.id
                    } label: {
                        if store.selectedStreamerID == streamer.id {
                            Label(streamer.name, systemImage: "checkmark")
                        } else {
                            Text(streamer.name)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text(currentStreamer?.name ?? "选择关注的主播")
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding(13)
                .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
            }
            .disabled(store.streamers.isEmpty)

            Button {
                showingAddStreamer = true
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(.red, in: RoundedRectangle(cornerRadius: 12))
            }
            .accessibilityLabel("添加主播")
        }
    }
}
