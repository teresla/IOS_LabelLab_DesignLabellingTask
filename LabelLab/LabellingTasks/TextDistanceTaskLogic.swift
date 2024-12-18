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

        // Filter attempts to match the selected category's dataset
        let availableAttempts = SwiftDataManager.shared.fetchTextDistanceAttempts(forUsername: username)
            .filter { $0.distanceText1 == 0 && $0.distanceText2 == 0 && dataset.contains($0.imageName) }
        
        if let attempt = availableAttempts.randomElement() {
            imageName = attempt.imageName
            text1 = attempt.text1
            text2 = attempt.text2
            text1Offset = .zero
            text2Offset = .zero
        } else {
            print("No available attempts for the user.")
        }
    }


    func saveAttempt() {
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
