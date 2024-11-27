import SwiftUI

struct AuthenticationPopup: View {
    @Binding var isSignUp: Bool
    var onAuthenticationComplete: (User) -> Void

    @State private var username: String = ""
    @State private var labellerCode: String = ""
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Sign Up" : "Log In")
                .font(.largeTitle)
                .bold()

            TextField("Enter Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if isSignUp {
                TextField("Enter Labeller Code (Optional)", text: $labellerCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(isSignUp ? "Sign Up" : "Log In") {
                isSignUp ? signUp() : logIn()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button(isSignUp ? "Switch to Log In" : "Switch to Sign Up") {
                isSignUp.toggle()
            }
            .font(.caption)
            .padding(.top, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .frame(maxWidth: 400, maxHeight: 400)
    }

    private func signUp() {
        let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !normalizedUsername.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        if SwiftDataManager.shared.isUsernameTaken(normalizedUsername) {
            errorMessage = "Username is already taken."
            return
        }

        var categories: [String] = []
        if !labellerCode.isEmpty {
            let validation = LabellerCodeManager.shared.validateCode(labellerCode)
            guard validation.isValid else {
                errorMessage = "Invalid or used labeller code."
                return
            }
            categories = validation.categories ?? []
            LabellerCodeManager.shared.markCodeAsUsed(labellerCode)
        }

        let newUser = User(username: normalizedUsername, labellerCode: labellerCode, categories: categories)
        SwiftDataManager.shared.saveUser(newUser)
        onAuthenticationComplete(newUser)
    }

    private func logIn() {
        let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !normalizedUsername.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        if let user = SwiftDataManager.shared.fetchAllUsers().first(where: { $0.username == normalizedUsername }) {
            onAuthenticationComplete(user)
        } else {
            errorMessage = "Username not found."
        }
    }
}
