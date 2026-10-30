import SwiftUI

@main
struct HuyaMonitorApp: App {
    @StateObject private var streamerStore = StreamerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(streamerStore)
                .preferredColorScheme(.dark)
        }
    }
}
