//
//  DataView.swift
//  LabelLab
//
//  Created by Teresa Windlin on 20.11.2024.
//

import SwiftUI

struct DataView: View {
    @State private var distanceAttempts: [DistanceAttempt] = []
    @State private var imageToTextAttempts: [ImageToTextAttempt] = []

    var body: some View {
        NavigationView {
            List {
                // Distance Attempts Section
                if !distanceAttempts.isEmpty {
                    Section(header: Text("Distance Attempts")) {
                        ForEach(distanceAttempts, id: \.id) { attempt in
                            VStack(alignment: .leading) {
                                Text("User ID: \(attempt.userId.uuidString)")
                                    .font(.caption)
                                Text("Image 1: \(attempt.image1Name)")
                                Text("Distance 1-2: \(attempt.distance1_2, specifier: "%.2f")")
                                Text("Distance 1-3: \(attempt.distance1_3, specifier: "%.2f")")
                                Text("Timestamp: \(attempt.timestamp, formatter: dateFormatter)")
                                    .font(.caption)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

                // Image to Text Attempts Section
                if !imageToTextAttempts.isEmpty {
                    Section(header: Text("Image to Text Attempts")) {
                        ForEach(imageToTextAttempts, id: \.id) { attempt in
                            VStack(alignment: .leading) {
                                Text("User ID: \(attempt.userId.uuidString)")
                                    .font(.caption)
                                Text("Image: \(attempt.imageName)")
                                Text("Text: \(attempt.text)")
                                    .lineLimit(2)
                                Text("Confirmation: \(attempt.confirmation)")
                                    .foregroundColor(attempt.confirmation > 0 ? .green : .red)
                                Text("Timestamp: \(attempt.timestamp, formatter: dateFormatter)")
                                    .font(.caption)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Saved Data")
            .onAppear {
                loadAttempts()
            }
        }
    }

    private func loadAttempts() {
        // Fetch data using SwiftDataManager
        distanceAttempts = SwiftDataManager.shared.fetchAllDistanceAttempts()
        imageToTextAttempts = SwiftDataManager.shared.fetchAllImageToTextAttempts()
    }
}

// Date Formatter for Timestamps
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
