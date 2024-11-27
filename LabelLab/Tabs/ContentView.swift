//
//  ContentView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 19.11.2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @State private var showMenu = false
    @State private var currentUser: User? = nil

    var body: some View {
        NavigationView {
            MainView()
                .navigationTitle("LabelLab")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            if let user = currentUser {
                                Text("Username: \(user.username)")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Divider()

                                Button("Settings") {
                                    // Navigate to SettingsView
                                    navigateToSettings()
                                }

                                Button("Logout") {
                                    logout()
                                }
                            } else {
                                Text("No user information available.")
                                    .foregroundColor(.red)
                            }

                            Divider()

                            Button("Data View") {
                                // Navigate to DataView
                                navigateToDataView()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                        }
                    }
                }
                .onAppear {
                    loadUser()
                }
        }
    }

    private func loadUser() {
        // Fetch the user from SwiftDataManager
        let users = SwiftDataManager.shared.fetchAllUsers()
        if let loggedInUser = users.first { // Replace with actual logic for fetching logged-in user
            currentUser = loggedInUser
        }
    }

    private func logout() {
        isLoggedIn = false
    }

    private func navigateToSettings() {
        // Add navigation logic for SettingsView here
        print("Navigating to Settings")
    }

    private func navigateToDataView() {
        // Add navigation logic for DataView here
        print("Navigating to Data View")
    }
}

