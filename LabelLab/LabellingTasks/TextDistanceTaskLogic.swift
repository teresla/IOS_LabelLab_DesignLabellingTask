import SwiftUI

@MainActor
class TextDistanceTaskLogic: ObservableObject {
    @Published var imageName: String = ""
    @Published var text1: String = "Descriptive Text 1"
    @Published var text2: String = "Descriptive Text 2"
    @Published var text1Offset: CGSize = .zero
    @Published var text2Offset: CGSize = .zero
    @Published var isDraggingText1: Bool = false
    @Published var isDraggingText2: Bool = false

    init() {
        reshuffleTask()
    }

    func reshuffleTask() {
        // Dummy placeholder values; in production, fetch random image and texts
        imageName = "example_image"
        text1 = "Elegant Design"
        text2 = "Classic Appeal"
        text1Offset = .zero
        text2Offset = .zero
    }

    func saveAttempt() {
        let distanceText1 = calculateNormalizedDistance(text1Offset)
        let distanceText2 = calculateNormalizedDistance(text2Offset)

        let attempt = TextDistanceAttempt(
            userId: UserSettings.shared.userId,
            imageName: imageName,
            text1: text1,
            text2: text2,
            distanceText1: distanceText1,
            distanceText2: distanceText2,
            timestamp: Date()
        )

        SwiftDataManager.shared.modelContainer.mainContext.insert(attempt)
        try? SwiftDataManager.shared.modelContainer.mainContext.save()

        reshuffleTask()
    }

    private func calculateNormalizedDistance(_ offset: CGSize) -> Double {
        let magnitude = sqrt(pow(Double(offset.width), 2) + pow(Double(offset.height), 2))
        return magnitude / 200.0
    }
}
