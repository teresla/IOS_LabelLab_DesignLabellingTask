import SwiftUI
import SwiftData

struct ImageToWhichTextTask: LabellingTask {
    let id = UUID()
    let title: String = "Image to which text"
    let description: String = "Set which text describe images better"
    let titelImage: Image = Image(ImageResource.iconWhichText)

    @State private var currentImage: String = ""
    @State private var text1: String = ""
    @State private var text2: String = ""
    @State private var selectedText: String? = nil
    @State private var showConfirmButton: Bool = false
    private let minEntries = 2

    var body: some View {
        VStack {
            // Top Image
            if let uiImage = UIImage(named: currentImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .padding()
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    selectedText = text2
                                } else if value.translation.width < -50 {
                                    selectedText = text1
                                }
                                showConfirmButton = selectedText != nil
                            }
                    )
            }

            Spacer()

            // Text Options
            HStack {
                Text(text1)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(selectedText == text1 ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                Text(text2)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(selectedText == text2 ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
            }

            Spacer()

            // Buttons
            HStack {
                Button("Reshuffle") {
                    reshuffle()
                }
                .buttonStyle(.borderedProminent)
                .padding()

                if showConfirmButton {
                    Button("Confirm") {
                        saveAttempt()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
        .onAppear {
            reshuffle()
        }
        .navigationTitle("Image to Which Text")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Reshuffle Function
    private func reshuffle() {
        // Fetch random entries from ImageToTextAttempt where confirmation = 0
        let attempts = SwiftDataManager.shared.fetchAllImageToTextAttempts().filter { $0.confirmation == 0 }
        guard let first = attempts.randomElement(),
              let second = attempts.filter({ $0.imageName == first.imageName && $0.id != first.id }).randomElement()
        else {
            currentImage = ""
            text1 = "No Data"
            text2 = "No Data"
            showConfirmButton = false
            return
        }

        currentImage = first.imageName
        text1 = first.text
        text2 = second.text
        selectedText = nil
        showConfirmButton = false
    }

    // Save Attempt Function
    private func saveAttempt() {
        guard let selectedText else { return }
        // Find the corresponding attempt and update confirmation
        var allAttempts = SwiftDataManager.shared.fetchAllImageToTextAttempts()
        if let attempt = allAttempts.first(where: { $0.imageName == currentImage && $0.text == selectedText }) {
            attempt.confirmation += 1
            SwiftDataManager.shared.saveImageToTextAttempt(attempt)
        }

        reshuffle()
    }
}
