import Foundation
import SwiftUI

@MainActor
class TextDistanceTaskLogic: ObservableObject {
    @Published var imageName: String = ""
    @Published var text1: String = ""
    @Published var text2: String = ""
    @Published var text1Offset: CGSize = .zero
    @Published var text2Offset: CGSize = .zero

    private let category: String

    private var dataset: [String] {
        switch category {
        case "Clothes":
            return ["edgypants", "sweatshirt", "sneakers", "bohodress", "dress", "jeans"]
        case "Furniture":
            return ["coutch", "chair", "antiquearmchair", "midcenturymodern"]
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
        let username = UserSettings.shared.username

        // Fetch images with at least two texts
        let imagesWithTexts = SwiftDataManager.shared.fetchImagesWithMultipleTexts(forUsername: username, minimumTexts: 2)
            .filter { dataset.contains($0.imageName) }

        guard let selectedImage = imagesWithTexts.randomElement() else {
            print("No available images with at least two texts for the user.")
            return
        }

        imageName = selectedImage.imageName

        // Randomly select two different texts
        if selectedImage.texts.count >= 2 {
            let shuffledTexts = selectedImage.texts.shuffled()
            text1 = shuffledTexts[0]
            text2 = shuffledTexts[1]
        } else {
            // Fallback if less than two texts are available
            text1 = selectedImage.texts.first ?? ""
            text2 = ""
        }

        text1Offset = .zero
        text2Offset = .zero
    }

    func saveAttempt() {
        // Calculate normalized distances (assuming this is how it's done)
        let distanceText1 = GeometryHelpers.normalizedDistance(text1Offset)
        let distanceText2 = GeometryHelpers.normalizedDistance(text2Offset)

        let attempt = TextDistanceAttempt(
            userId: UserSettings.shared.id,
            username: UserSettings.shared.username,
            imageName: imageName,
            text1: text1,
            text2: text2,
            distanceText1: distanceText1,
            distanceText2: distanceText2,
            timestamp: Date()
        )

        SwiftDataManager.shared.saveTextDistanceAttempt(attempt, username: UserSettings.shared.username)
        reshuffle()
    }
}
