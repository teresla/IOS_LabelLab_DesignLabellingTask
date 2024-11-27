//
//  ToolbarMenu.swift
//  LabelLab
//
//  Created by Teresa Windlin on 25.11.2024.
//
import SwiftUI

struct ToolbarMenu: View {
    let currentUser: User?
    let onSettings: () -> Void
    let onRewardsView: () -> Void
    let onLogout: () -> Void

    var body: some View {
        Menu {
            if let user = currentUser {
                Text("Username: \(user.username)")
                    .font(.headline)
                    .foregroundColor(.primary)

                Divider()

                Button("Settings", action: onSettings)
                Button("Rewards", action: onRewardsView)
                Button("Logout", action: onLogout)
            } else {
                Text("No user information available.")
                    .foregroundColor(.red)
            }
        } label: {
            Image(systemName: "ellipsis")
                .imageScale(.large)
        }
    }
}
