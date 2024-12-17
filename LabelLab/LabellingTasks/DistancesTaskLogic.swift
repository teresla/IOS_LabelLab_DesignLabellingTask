import Foundation
import SwiftUI

@MainActor
class DistancesTaskLogic: ObservableObject {
    @Published var image1: String = ""
    @Published var image2: String = ""
    @Published var image3: String = ""
    @Published var leftOffset: CGSize = .zero
    @Published var rightOffset: CGSize = .zero
    
    private let category: String

    private var dataset: [String] {
        switch category {
        case "Clothes":
            return ["edgy pants", "sweatshirt", "sneakers", "bohodress", "dress", "jeans"]
        case "Furniture":
            return ["couch", "chair", "antiquearmchair", "midcenturymodern"]
        default:
            return ["0_1_aug", "0_2_aug", "0_cw", "0_prouds", "0_wb", "0",
                    "1_1_aug", "1_2_aug", "1_cw", "1_prouds", "1_wb", "1",
                    "2_1_aug", "2_2_aug", "2_cw", "2_prouds", "2_wb", "2"]
        }
    }

    init(category: String) {
        self.category = category
        reshuffle()
    }

    func reshuffle() {
        // Shuffle the dataset to select new images
        let shuffled = dataset.shuffled()
        image1 = shuffled[0]
        image2 = shuffled[1]
        image3 = shuffled[2]
        leftOffset = .zero
        rightOffset = .zero
    }
    
    func saveAttempt() {
        let distance1_2 = GeometryHelpers.normalizedDistance(leftOffset)
        let distance1_3 = GeometryHelpers.normalizedDistance(rightOffset)

        // Fetch user data from UserSettings
        let userId = UserSettings.shared.id
        let username = UserSettings.shared.username

        let attempt = DistanceAttempt(
            userId: userId,
            username: username,
            image1Name: image1,
            image2Name: image2,
            image3Name: image3,
            distance1_2: distance1_2,
            distance1_3: distance1_3,
            timestamp: Date()
        )

        SwiftDataManager.shared.saveDistanceAttempt(attempt, username: username)
        reshuffle()
    }
}
