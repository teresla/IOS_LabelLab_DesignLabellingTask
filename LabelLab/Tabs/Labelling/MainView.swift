import SwiftUI

struct MainView: View {
    @EnvironmentObject private var userSettings: UserSettings

    @State private var showSettings: Bool = false
    @State private var showRewards: Bool = false
    @State private var showAllData: Bool = false
    @State private var showMonetizationDetail: Bool = false
    @State private var showAuthPopup: Bool = false
    @State private var showLoginView: Bool = false
    
    @State private var isSignUpMode: Bool = true

    var body: some View {
        VStack {
            Text("Hello, \(userSettings.username.isEmpty ? "Guest" : userSettings.username.capitalized)!")
                .font(.largeTitle)
                .padding()

            TaskListView(onStartTask: { task in
                print("Starting task: \(task.title)")
            })
            .padding()

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarMenu(
                    currentUser: userSettings.isLoggedIn ? userSettings.username : nil,
                    onSignIn: { showAuthPopup = true },
                    onSettings: { showSettings = true },
                    onRewards: { showRewards = true },
                    onSignOut: { signOut() }
                )
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(userSettings)
        }
        .sheet(isPresented: $showRewards) {
            RewardsView(userId: userSettings.id, username: userSettings.username)
        }
        .sheet(isPresented: $showAllData) {
            AllDataView()
                .environmentObject(userSettings)
        }
        .sheet(isPresented: $showMonetizationDetail) {
            MonetizationDetailsView(
                username: .constant(userSettings.username),
                onComplete: handleMonetizationComplete
            )
        }
        .sheet(isPresented: $showAuthPopup) {
            AuthenticationPopup(isSignUp: $isSignUpMode) { user in
                userSettings.updateForUser(user: user)
                showAuthPopup = false
            }
        }
        .sheet(isPresented: $showLoginView) {
            LoginView(isAuthenticated: Binding(
                get: { userSettings.isLoggedIn },
                set: { newValue in
                    if !newValue {
                        userSettings.resetToGuest()
                    }
                }
            ))
            .environmentObject(userSettings)
        }
    }

    private func signOut() {
        userSettings.resetToGuest()
        showLoginView = true
    }

    private func handleMonetizationComplete(newUser: User) {
        userSettings.updateForUser(user: newUser)
    }
}
