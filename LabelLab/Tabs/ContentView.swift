import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showAuthPopup: Bool = false
    @State private var isSignUp: Bool = true

    var body: some View {
        NavigationView {
            ZStack {
                MainView() // MainView now incorporates the toolbar logic
                    .environmentObject(userSettings)

                if showAuthPopup {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { showAuthPopup = false }

                    AuthenticationPopup(isSignUp: $isSignUp) { user in
                        userSettings.updateForUser(user: user)
                        showAuthPopup = false
                    }
                    .frame(maxWidth: 400, maxHeight: 400)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Proper display on iPad
    }
}
