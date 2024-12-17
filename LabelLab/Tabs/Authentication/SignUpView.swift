import SwiftUI

struct SignupView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var showNextPage: Bool = false
    @State private var monetizationReason: String = ""
    @State private var linkedinLink: String = ""

    var body: some View {
        VStack {
            if showNextPage {
                MonetizationDetailsView(
                    username: $username,
                    onComplete: handleSignupComplete
                )
            } else {
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    TextField("Enter your username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)

                    Button(action: {
                        if !username.trimmingCharacters(in: .whitespaces).isEmpty {
                            showNextPage = true
                        }
                    }) {
                        Text("Next")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }

    private func handleSignupComplete(newUser: User) {
        // Automatically log in the user after signing up
        SwiftDataManager.shared.saveUser(newUser)
        userSettings.updateForUser(user: newUser)
        isAuthenticated = true
    }
}
