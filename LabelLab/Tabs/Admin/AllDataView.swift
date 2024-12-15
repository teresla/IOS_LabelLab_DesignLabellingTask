import SwiftUI

struct AllDataView: View {
    @State private var distanceAttempts: [DistanceAttempt] = []
    @State private var imageToTextAttempts: [ImageToTextAttempt] = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Distance Attempts")) {
                    ForEach(distanceAttempts, id: \.id) { attempt in
                        Text("Image: \(attempt.image1Name) - Distance1_2: \(attempt.distance1_2)")
                    }
                }

                Section(header: Text("Image to Text Attempts")) {
                    ForEach(imageToTextAttempts, id: \.id) { attempt in
                        Text("Image: \(attempt.imageName) - Text: \(attempt.text)")
                    }
                }
            }
            .navigationTitle("All Data")
            .onAppear {
                loadData()
            }
        }
    }

    private func loadData() {
        distanceAttempts = SwiftDataManager.shared.fetchAllDistanceAttempts()
        imageToTextAttempts = SwiftDataManager.shared.fetchAllImageToTextAttempts()
    }
}
