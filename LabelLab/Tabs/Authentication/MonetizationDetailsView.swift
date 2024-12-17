import SwiftUI

struct MonetizationDetailsView: View {
    @Binding var username: String
    var onComplete: (User) -> Void

    @State private var monetizationReason: String = ""
    @State private var linkedinLink: String = ""
    @Environment(\.presentationMode) private var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage: String = ""

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
                TextField("LinkedIn Profile (Optional)", text: $linkedinLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .padding(.horizontal)
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
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
    }

    private func submitRequest() {
        // Validate monetization reason
        if monetizationReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please provide a reason for monetization request."
            showingAlert = true
            return
        }
        
        // Validate LinkedIn link if it's provided
        var validatedLinkedInLink: String? = nil
        if !linkedinLink.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let url = URL(string: linkedinLink), UIApplication.shared.canOpenURL(url) else {
                alertMessage = "Please provide a valid LinkedIn URL."
                showingAlert = true
                return
            }
            validatedLinkedInLink = linkedinLink
        }
        
        // Proceed with submission
        let newUser = User(username: username, isMonetized: true, linkedinLink: validatedLinkedInLink)
        onComplete(newUser)
        presentationMode.wrappedValue.dismiss()
    }
}
