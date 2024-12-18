import SwiftUI

struct ToolbarMenu: View {
    let currentUser: String?
    let onSignIn: () -> Void
    let onSettings: () -> Void
    let onRewards: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        Menu {
            if let currentUser = currentUser {
                Text("Welcome, \(currentUser.capitalized)")
                    .font(.headline)

                Button(action: onSettings) {
                    Label("Settings", systemImage: "gearshape")
                }

                Button(action: onRewards) {
                    Label("Rewards", systemImage: "star.fill")
                }

                Divider()

                Button(role: .destructive, action: onSignOut) {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } else {
                Button(action: onSignIn) {
                    Label("Sign In", systemImage: "person.fill")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title)
                .foregroundColor(.primary)
        }
    }
}
