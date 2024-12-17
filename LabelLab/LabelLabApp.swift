import SwiftUI

@main
struct LabelLabApp: App {
    @StateObject private var userSettings = UserSettings.shared
    @State private var isAuthenticated: Bool = false // Track authentication state


    var body: some Scene {
        WindowGroup {
            if userSettings.isLoggedIn || isAuthenticated {
                ContentView()
                    .environmentObject(userSettings)
            } else {
                LoginView(isAuthenticated: $isAuthenticated) // Pass Binding here
                    .environmentObject(userSettings)
            }

        }
    }
}
