import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showMonetizationAlert: Bool = false
    @State private var monetizationMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)

                Text("Username: \(userSettings.username)")
                    .font(.subheadline)

                Text("User ID: \(userSettings.id.uuidString)")
                    .font(.subheadline)

                Text("Is Admin: \(userSettings.isAdmin ? "Yes" : "No")")
                    .font(.subheadline)

                Text("Is Monetized: \(userSettings.isMonetized ? "Yes" : "No")")
                    .font(.subheadline)
                    .padding(.top, 5)

                VStack(alignment: .leading) {
                    Text("Preferred Category: Watches")
                        .font(.headline)
                }
                .padding(.top, 20)

                Button(action: {
                    showMonetizationAlert = true
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Text("Apply for Monetization")
                            .foregroundColor(.blue)
                    }
                }
                .alert("Apply for Monetization", isPresented: $showMonetizationAlert) {
                    TextField("Enter your message...", text: $monetizationMessage)
                    Button("Send", action: submitMonetizationRequest)
                    Button("Cancel", role: .cancel) {}
                }

                Spacer()
            }
            .padding()
        }
    }

    private func submitMonetizationRequest() {
        print("Monetization request sent with message: \(monetizationMessage)")
        monetizationMessage = ""
    }
}
