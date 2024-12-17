//
//  LoginView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 16.12.2024.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Log In")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button("Log In") {
                    logIn()
                }
                .buttonStyle(.borderedProminent)
                .padding()

                NavigationLink(destination: SignupView(isAuthenticated: $isAuthenticated)) {
                    Text("Don't have an account? Sign Up")
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
        }
    }

    private func logIn() {
        let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !normalizedUsername.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        if let user = SwiftDataManager.shared.fetchAllUsers().first(where: { $0.username == normalizedUsername }) {
            userSettings.updateForUser(user: user)
            isAuthenticated = true
        } else {
            errorMessage = "Username not found."
        }
    }
}
