//
//  AuthenticationPopup.swift
//  LabelLab
//
//  Created by Teresa Windlin on 17.12.2024.
//


import SwiftUI

struct AuthenticationPopup: View {
    @Binding var isSignUp: Bool
    var onAuthentication: (User) -> Void

    @State private var username: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Sign Up" : "Log In")
                .font(.title)
                .fontWeight(.bold)

            // Username Field
            TextField("Enter Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Submit Button
            Button(action: authenticateUser) {
                Text(isSignUp ? "Sign Up" : "Log In")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Switch between Sign Up and Log In
            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .frame(maxWidth: 350)
    }

    private func authenticateUser() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedUsername.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        if isSignUp {
            // Handle Sign Up
            let newUser = User(username: trimmedUsername, isMonetized: false)
            SwiftDataManager.shared.saveUser(newUser)
            UserSettings.shared.updateForUser(user: newUser) // Update global UserSettings
            onAuthentication(newUser) // Notify parent view
        } else {
            // Handle Log In
            if let existingUser = SwiftDataManager.shared.fetchAllUsers().first(where: { $0.username == trimmedUsername }) {
                UserSettings.shared.updateForUser(user: existingUser) // Update global UserSettings
                onAuthentication(existingUser) // Notify parent view
            } else {
                errorMessage = "Username not found."
            }
        }
    }
}
