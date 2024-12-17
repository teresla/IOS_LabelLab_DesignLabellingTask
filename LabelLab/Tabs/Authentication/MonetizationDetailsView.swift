import SwiftUI

struct MonetizationDetailsView: View {
    @Binding var username: String
    var onComplete: (User) -> Void

    @State private var monetizationReason: String = ""
    @State private var linkedInLink: String = ""
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Request Monetization")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Reason Text Field
            VStack(alignment: .leading, spacing: 10) {
                Text("Reason")
                    .font(.headline)
                TextField("Why should you receive monetization?", text: $monetizationReason)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // LinkedIn Link Text Field
            VStack(alignment: .leading, spacing: 10) {
                Text("LinkedIn Link (optional)")
                    .font(.headline)
                TextField("Enter your LinkedIn profile link", text: $linkedInLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Submit Button
            Button(action: submitRequest) {
                Text("Submit")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }

    private func submitRequest() {
        let newUser = User(username: username, isMonetized: !monetizationReason.isEmpty)
        onComplete(newUser) // Pass the new user back to the SignupView
        presentationMode.wrappedValue.dismiss() // Dismiss this view
    }
}
