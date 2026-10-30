import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MonitorView()
            }
            .tabItem {
                Label("监控", systemImage: "dot.radiowaves.left.and.right")
            }

            NavigationStack {
                FollowedView()
            }
            .tabItem {
                Label("关注主播", systemImage: "heart")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape")
            }
        }
        .tint(.red)
    }
}
