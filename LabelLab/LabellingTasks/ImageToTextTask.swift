import SwiftUI

struct ImageToTextTask: LabellingTask {
    let id = UUID()
    let title: String = "Image to Text"
    let description: String = "Convert an image to text."
    let titelImage: Image = Image(ImageResource.iconToText)
    let category: String

    @StateObject private var logic: ImageToTextTaskLogic
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var keyboardResponder = KeyboardResponder()

    init(category: String) {
        self.category = category
        _logic = StateObject(wrappedValue: ImageToTextTaskLogic(category: category))
    }

    var body: some View {
        TaskContainerView(
            taskTitle: title,
            onSubmit: { 
                logic.saveAttempt()
                hideKeyboard()
            },
            onReshuffle: { 
                logic.shuffleImage()
                hideKeyboard()
            }
        ) {
            VStack(spacing: 20) {
                // Center Image Display with Accent Blue Border
                if let uiImage = UIImage(named: logic.currentImage) {
                    ZStack {
                        // Accent Blue Border - Slightly Larger than the Image
                        Circle()
                            .stroke(Color("AccentBlue"), lineWidth: 6)
                            .frame(width: adjustedImageSize() * 3.2, height: adjustedImageSize() * 3.2)

                        // Image
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: adjustedImageSize() * 3, height: adjustedImageSize() * 3)
                            .clipShape(Circle())
                    }
                    .animation(.easeInOut, value: keyboardResponder.keyboardHeight)
                }

                // Textbox with Rounded Corners
                TextField("Describe the image...", text: $logic.textInput)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(logic.isTextValid ? Color.green : Color.red, lineWidth: 2)
                    )
                    .padding([.leading, .trailing], 40)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isTextFieldFocused = true
                        }
                    }

                Text("Character count: \(logic.textInput.count)/\(logic.maxCharacters)")
                    .font(.caption)
                    .foregroundColor(logic.isTextValid ? .green : .red)
            }
            .padding(.top, 20)
            .padding(.bottom, keyboardResponder.keyboardHeight)
            .animation(.easeInOut, value: keyboardResponder.keyboardHeight)
        }
        .navigationBarHidden(true)
    }

    // Helper method to hide keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Calculate adjusted image size based on keyboard presence
    private func adjustedImageSize() -> CGFloat {
        let baseSize = UIScreen.main.bounds.width * 0.28
        let keyboardVisible = keyboardResponder.keyboardHeight > 0
        return keyboardVisible ? baseSize * 0.8 : baseSize
    }
}
