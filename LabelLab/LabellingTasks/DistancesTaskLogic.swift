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
    @Published var image2Offset: CGFloat = 0.0
    @Published var image3Offset: CGFloat = 0.0

    init() {
        reshuffleImages()
    }

    // Reshuffle images
    func reshuffleImages() {
        let shuffled = dataset.shuffled()
        image1 = shuffled[0]
        image2 = shuffled[1]
        image3 = shuffled[2]
        image2Offset = 0.0
        image3Offset = 0.0
    }

    // Save distances
    func saveDistances() {
        // Calculate distances
        let distance1_2 = Double(abs(image2Offset) / 200.0) // Normalize distances (example scale)
        let distance1_3 = Double(abs(image3Offset) / 200.0)

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
}
