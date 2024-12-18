import SwiftUI
import UIKit

struct DistancesTask: LabellingTask {
    let id = UUID()
    let title: String = "Image Similarity Task"
    let description: String = "Drag the top two images so theyr distance to the bottom image represents the similarity between them."
    let titelImage: Image = Image(ImageResource.iconDistances)
    let category: String

    @State private var enlargedIndex: Int? = nil
    @StateObject private var logic: DistancesTaskLogic

    init(category: String) {
        self.category = category
        _logic = StateObject(wrappedValue: DistancesTaskLogic(category: category))
    }
    
    var body: some View {
        TaskContainerView(
            taskTitle: "Image Similarity Task",
            onSubmit: { logic.saveAttempt() },
            onReshuffle: { logic.reshuffle() }
        ) {
            DistanceBaseView<Image, Image, Image>(
                leftOffset: $logic.leftOffset,
                rightOffset: $logic.rightOffset,
                enlargedIndex: $enlargedIndex,
                lineThickness: 3.0,
                centerContent: {
                    Image(logic.image1)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                leftContent: {
                    Image(logic.image2)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                rightContent: {
                    Image(logic.image3)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            )
        }
        .navigationBarHidden(true)
    }
}

