import SwiftUI

struct ImageToTextTask: LabellingTask {
    let id = UUID()
    let title: String = "Image to Text"
    let description: String = "Convert an image to text."
    let titelImage: Image = Image(ImageResource.iconToText)
    let category: String

    @StateObject private var logic: ImageToTextTaskLogic

    init(category: String) {
        self.category = category
        _logic = StateObject(wrappedValue: ImageToTextTaskLogic(category: category))
    }

    var body: some View {
        TaskContainerView(
            taskTitle: title,
            onSubmit: { logic.saveAttempt() },
            onReshuffle: { logic.shuffleImage() }
        ) {
            GeometryReader { geometry in
                let imageSize = geometry.size.width * 0.28

                VStack(spacing: 20) {
                    Spacer()

                    // Center Image Display with Accent Blue Border
                    if let uiImage = UIImage(named: logic.currentImage) {
                        ZStack {
                            // Accent Blue Border - Slightly Larger than the Image
                            Circle()
                                .stroke(Color("AccentBlue"), lineWidth: 6)
                                .frame(width: imageSize * 3.2, height: imageSize * 3.2)

                            // Image
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize * 3, height: imageSize * 3)
                                .clipShape(Circle())
                        }
                    }

                    // Textbox with Rounded Corners
                    TextField("Describe the image...", text: $logic.textInput)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(logic.isTextValid ? Color.green : Color.red, lineWidth: 2)
                        )
                        .padding([.leading, .trailing], 40)

                    Text("Character count: \(logic.textInput.count)/\(logic.maxCharacters)")
                        .font(.caption)
                        .foregroundColor(logic.isTextValid ? .green : .red)

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
