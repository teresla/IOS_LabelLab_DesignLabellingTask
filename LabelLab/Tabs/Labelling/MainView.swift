import SwiftUI

struct MainView: View {
    @State private var isLoggedIn: Bool = false
    @State private var currentUser: User? = nil
    @State private var showAuthModal: Bool = false
    @State private var isSignUp: Bool = true
    @State private var showSettings: Bool = false
    @State private var showRewardsView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    TaskListView()
                } else {
                    Text("Please log in to access tasks.")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationTitle("LabelLab")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarMenu(
                        currentUser: currentUser,
                        onSettings: { showSettings = true },
                        onRewardsView: { showRewardsView = true },
                        onLogout: logout
                    )
                }
            }
            .onAppear {
                checkAuthentication()
            }
            .fullScreenCover(isPresented: $showAuthModal) {
                AuthenticationPopup(
                    isSignUp: $isSignUp,
                    onAuthenticationComplete: { user in
                        currentUser = user
                        isLoggedIn = true
                        showAuthModal = false
                    }
                )
                .interactiveDismissDisabled(true) // Prevent swiping away
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isLoggedIn: $isLoggedIn)
            }
            .sheet(isPresented: $showRewardsView) {
                RewardsView(user: currentUser)
            }
        }
    }

    private func checkAuthentication() {
        if let loggedInUser = SwiftDataManager.shared.fetchAllUsers().first {
            currentUser = loggedInUser
            isLoggedIn = true
        } else {
            showAuthModal = true
        }
    }

    private func logout() {
        isLoggedIn = false
        currentUser = nil
        showAuthModal = true // Force authentication popup
    }
}
