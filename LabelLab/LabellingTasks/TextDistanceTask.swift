import SwiftUI

struct TextDistanceTask: LabellingTask {
    let id = UUID()
    let title: String = "Text Similarity Task"
    let description: String = "Arrange the top two textss at distances from the bottom image that accurately reflect their conceptiual similarities."
    let titelImage: Image = Image(ImageResource.iconWhichText)

    let category: String

    @State private var enlargedIndex: Int? = nil
    @StateObject private var logic: TextDistanceTaskLogic

    init(category: String) {
        self.category = category
        _logic = StateObject(wrappedValue: TextDistanceTaskLogic(category: category))
    }

    var body: some View {
        TaskContainerView(
            taskTitle: "Text Similarity Task",
            onSubmit: {
                logic.saveAttempt() // Use logic.saveAttempt() to save data
            },
            onReshuffle: {
                logic.reshuffle() // Use logic.reshuffle() to get new data
            }
        ) {
            DistanceBaseView<Image, TextVisualView, TextVisualView>(
                leftOffset: $logic.text1Offset,
                rightOffset: $logic.text2Offset,
                enlargedIndex: $enlargedIndex,
                lineThickness: 3.0,
                centerContent: {
                    if !logic.imageName.isEmpty {
                        Image(logic.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } else {
                        Circle() // Placeholder if imageName is empty
                            .fill(Color.gray.opacity(0.3))
                            .overlay(Text("No Image"))
                    }
                },
                leftContent: {
                    TextVisualView(
                        text: logic.text1
                    )
                },
                rightContent: {
                    TextVisualView(
                        text: logic.text2
                    )
                }
            )
        }
        .onAppear {
            logic.reshuffle() // Fetch data on view appear
        }
        .navigationBarHidden(true)
    }
}
