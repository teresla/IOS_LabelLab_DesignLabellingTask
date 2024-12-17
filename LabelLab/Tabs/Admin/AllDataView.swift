//
//  AllDataView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 15.12.2024.
//


import SwiftUI

struct AllDataView: View {
    @State private var distanceAttempts: [DistanceAttempt] = []
    @State private var imageToTextAttempts: [ImageToTextAttempt] = []
    @State private var textDistanceAttempts: [TextDistanceAttempt] = []

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
                Section(header: Text("Distance Attempts")) {
                    ForEach(distanceAttempts, id: \.id) { attempt in
                        Text("Image1: \(attempt.image1Name), Image2: \(attempt.image2Name), Image3: \(attempt.image3Name) - Distances: \(attempt.distance1_2), \(attempt.distance1_3)")
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
        textDistanceAttempts = SwiftDataManager.shared.fetchAllTextDistanceAttempts()
    }
}
