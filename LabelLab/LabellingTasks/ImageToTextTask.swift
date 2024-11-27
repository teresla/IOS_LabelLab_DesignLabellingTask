//
//  ImageToText.swift
//  LabelLab
//
//  Created by Teresa Windlin on 13.11.2024.
//

import SwiftUI

struct ImageToTextTask: LabellingTask {
    let id = UUID()
    let title: String = "Image to Text"
    let description: String = "Convert an image to text."
    let titelImage: Image = Image(systemName: "arrow.2.circlepath.circle")

    // Dataset of image names
    let dataset = ["0_1_aug", "0_2_aug", "0_cw", "0_prouds", "0_wb", "0",
                   "1_1_aug", "1_2_aug", "1_cw", "1_prouds", "1_wb", "1",
                   "2_1_aug", "2_2_aug", "2_cw", "2_prouds", "2_wb", "2"]
    @State private var currentImage: String = ""
    @State private var textInput: String = ""
    @State private var showConfirmButton: Bool = false

    private let minCharacters = 10
    private let maxCharacters = 100

    var body: some View {
        VStack {
            // Random Image Display
            if let uiImage = UIImage(named: currentImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .padding()
            }

            // Textbox with Character Limit
            TextField("Describe the image...", text: $textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: textInput) { newValue in
                    // Enforce character limits
                    if newValue.count < minCharacters || newValue.count > maxCharacters {
                        showConfirmButton = false
                    } else {
                        showConfirmButton = true
                    }
                    // Trim text if it exceeds the maxCharacters
                    if newValue.count > maxCharacters {
                        textInput = String(newValue.prefix(maxCharacters))
                    }
                }

            Text("Character count: \(textInput.count)/\(maxCharacters)")
                .font(.caption)
                .foregroundColor(textInput.count < minCharacters ? .red : .green)

            Spacer()

            // Shuffle Button
            Button("Shuffle Image") {
                shuffleImage()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            // Confirm Button (Only Visible When Text is Valid)
            if showConfirmButton {
                Button("Confirm") {
                    saveAttempt()
                }
                .buttonStyle(.bordered)
                .padding()
            }
        }
        .onAppear {
            shuffleImage()
        }
        .navigationTitle("Image to Text")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Shuffle Image Function
    private func shuffleImage() {
        currentImage = dataset.randomElement() ?? "image1"
        textInput = ""
        showConfirmButton = false
    }

    // Save Attempt Function
    private func saveAttempt() {
        let attempt = ImageToTextAttempt(
            userId: UserSettings.shared.userId,
            imageName: currentImage,
            text: textInput,
            timestamp: Date()
        )

        SwiftDataManager.shared.saveImageToTextAttempt(attempt)
    }

}
