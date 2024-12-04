//
//  DistancesTaskLogic.swift
//  LabelLab
//
//  Created by Teresa Windlin on 13.11.2024.
//

import Foundation
import SwiftUI

@MainActor
class DistancesTaskLogic: ObservableObject {
    let dataset = ["0_1_aug", "0_2_aug", "0_cw", "0_prouds", "0_wb", "0",
                   "1_1_aug", "1_2_aug", "1_cw", "1_prouds", "1_wb", "1",
                   "2_1_aug", "2_2_aug", "2_cw", "2_prouds", "2_wb", "2"]

    @Published var image1: String = ""
    @Published var image2: String = ""
    @Published var image3: String = ""
    @Published var image2Offset: CGSize = .zero
    @Published var image3Offset: CGSize = .zero
    @Published var isImage2Held: Bool = false
    @Published var isImage3Held: Bool = false
    @Published var isDragging2: Bool = false
    @Published var isDragging3: Bool = false
    @Published var isImage1Held: Bool = false

    init() {
        reshuffleImages()
    }

    // Reshuffle images
    func reshuffleImages() {
        let shuffled = dataset.shuffled()
        image1 = shuffled[0]
        image2 = shuffled[1]
        image3 = shuffled[2]
        image2Offset = .zero
        image3Offset = .zero
    }

    // Save distances
    func saveDistances() {
        // Calculate distances - now using vector magnitude
        let distance1_2 = calculateNormalizedDistance(image2Offset)
        let distance1_3 = calculateNormalizedDistance(image3Offset)

        // Create DistanceAttempt
        let attempt = DistanceAttempt(
            userId: UserSettings.shared.userId,
            image1Name: image1,
            image2Name: image2,
            image3Name: image3,
            distance1_2: distance1_2,
            distance1_3: distance1_3,
            timestamp: Date()
        )

        // Save attempt
        SwiftDataManager.shared.saveDistanceAttempt(attempt)

        // Automatically reshuffle after saving
        reshuffleImages()
    }

    // Helper function to calculate normalized distance from CGSize
    private func calculateNormalizedDistance(_ offset: CGSize) -> Double {
        let magnitude = sqrt(pow(Double(offset.width), 2) + pow(Double(offset.height), 2))
        return magnitude / 200.0  // Normalize using the same scale factor
    }
}
