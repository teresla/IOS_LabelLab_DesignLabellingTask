//
//  ImageToTextTaskLogic.swift
//  LabelLab
//
//  Created by Teresa Windlin on 16.12.2024.
//


import SwiftUI

@MainActor
class ImageToTextTaskLogic: ObservableObject {
    @Published var currentImage: String = ""
    @Published var textInput: String = ""

    let maxCharacters = 15
    let minCharacters = 5

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
        shuffleImage()
    }

    var isTextValid: Bool {
        textInput.count >= minCharacters && textInput.count <= maxCharacters
    }

    func shuffleImage() {
        currentImage = dataset.randomElement() ?? "defaultImage"
        textInput = ""
    }

    func saveAttempt() {
        guard isTextValid else { return }

        let username = UserSettings.shared.username
        let attempt = ImageToTextAttempt(
            userId: UserSettings.shared.id,
            username: username,
            imageName: currentImage,
            text: textInput,
            timestamp: Date()
        )

        SwiftDataManager.shared.saveImageToTextAttempt(attempt, username: username)
        shuffleImage()
    }
}
