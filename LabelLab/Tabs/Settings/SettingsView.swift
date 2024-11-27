//
//  SettingsView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 18.11.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isLoggedIn: Bool
    @State private var currentUser: User?
    @Environment(UserSettings.self) private var userSettings

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if let user = currentUser {
                    Text("User Information")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)

                    Text("User ID: \(user.id.uuidString)")
                        .font(.headline)

                    Text("Username: \(user.username)")
                        .font(.subheadline)

                    Toggle("Dark Mode", isOn: Binding(
                        get: { user.isDarkModeEnabled },
                        set: { newValue in
                            updateDarkMode(for: user, enabled: newValue)
                        }
                    ))
                    .padding(.top, 20)
                } else {
                    Text("No user information available.")
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .onAppear {
                loadUser()
            }
        }
    }

    private func loadUser() {
        if let loggedInUser = SwiftDataManager.shared.fetchAllUsers().first {
            currentUser = loggedInUser
        }
    }

    private func updateDarkMode(for user: User, enabled: Bool) {
        guard let index = SwiftDataManager.shared.fetchAllUsers().firstIndex(where: { $0.id == user.id }) else {
            return
        }
        SwiftDataManager.shared.updateUser(index: index) { user in
            user.isDarkModeEnabled = enabled
        }
        userSettings.alwaysUseDarkMode = enabled
    }
}
