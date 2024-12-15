import SwiftUI

struct MonetizationRequestsView: View {
    @State private var monetizationRequests: [LabellerCode] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(monetizationRequests.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Code: \(monetizationRequests[index].code)")
                                .font(.headline)
                            Text("Categories: \(monetizationRequests[index].categories.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button("Approve") {
                            approveRequest(index: index)
                        }
                        .foregroundColor(.green)
                        Button("Deny") {
                            denyRequest(index: index)
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Monetization Requests")
            .onAppear {
                loadMonetizationRequests()
            }
        }
    }

    private func loadMonetizationRequests() {
        monetizationRequests = LabellerCodeManager.shared.codes.filter { !$0.isUsed }
    }

    private func approveRequest(index: Int) {
        LabellerCodeManager.shared.markCodeAsUsed(monetizationRequests[index].code)
        monetizationRequests.remove(at: index)
    }

    private func denyRequest(index: Int) {
        monetizationRequests.remove(at: index)
    }
}
