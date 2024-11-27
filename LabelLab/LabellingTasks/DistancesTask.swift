import SwiftUI

struct DistancesTask: LabellingTask {
    let id = UUID()
    let title: String = "Distance"
    let description: String = "Move the middle element according to their design language."
    let titelImage: Image = Image(systemName: "arrow.2.circlepath.circle")

    @StateObject private var logic = DistancesTaskLogic()

    var body: some View {
        GeometryReader { geometry in
            // Naming conventions
            let XAnker = geometry.size.width / 2
            let YAnker = geometry.size.height * 0.6 // Adjusted Y position for center image
            let XOffset = geometry.size.width / 4 // Horizontal offset for Image 2 and Image 3
            let YOffset = geometry.size.height * 0.25 // How far the lines go up
            let imageSize = geometry.size.width * 0.28 // Increased by 40%

            VStack(spacing: 0) {
                // Title and description at the top
                VStack(alignment: .center, spacing: 10) {
                    Text("Image Similarity Task")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, geometry.safeAreaInsets.top)

                    Text("Drag the images along the lines to show their similarity to the center image.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)

                Spacer() // Space between title and interactive content

                // Interactive content: Lines and images above the buttons
                ZStack {
                    // Fixed Lines
                    Path { path in
                        // Left Line
                        path.move(to: CGPoint(x: XAnker - XOffset, y: YAnker - YOffset))
                        path.addLine(to: CGPoint(x: XAnker, y: YAnker))

                        // Right Line
                        path.move(to: CGPoint(x: XAnker + XOffset, y: YAnker - YOffset))
                        path.addLine(to: CGPoint(x: XAnker, y: YAnker))
                    }
                    .stroke(Color.red, lineWidth: 3) // Red, fixed lines

                    // Images
                    ZStack {
                        // Center Image (Image 1)
                        ImageView(imageName: logic.image1, circleColor: .green)
                            .frame(width: imageSize * 1.2, height: imageSize * 1.2) // Larger size
                            .position(x: XAnker, y: YAnker - (imageSize * 0.6)) // Moved up by 50% of its height

                        // Image 2 (Left)
                        ImageView(imageName: logic.image2, circleColor: .orange)
                            .frame(width: imageSize, height: imageSize)
                            .position(
                                x: XAnker - XOffset,
                                y: YAnker - YOffset + logic.image2Offset
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        logic.image2Offset = calculateOffsetAlongLine(value: value, lineStart: YAnker - YOffset, lineEnd: YAnker)
                                    }
                            )

                        // Image 3 (Right)
                        ImageView(imageName: logic.image3, circleColor: .cyan)
                            .frame(width: imageSize, height: imageSize)
                            .position(
                                x: XAnker + XOffset,
                                y: YAnker - YOffset + logic.image3Offset
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        logic.image3Offset = calculateOffsetAlongLine(value: value, lineStart: YAnker - YOffset, lineEnd: YAnker)
                                    }
                            )
                    }
                }
                .padding(.bottom, 20) // Space above buttons

                // Buttons for Reshuffle and Confirm
                HStack(spacing: 20) {
                    // Reshuffle Button
                    Button(action: { logic.reshuffleImages() }) {
                        Text("Reshuffle")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: geometry.size.width * 0.35, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 3)
                    }

                    // Confirm Button
                    Button(action: { logic.saveDistances() }) {
                        Text("Confirm")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: geometry.size.width * 0.35, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20) // Ensure padding with safe area
            }
        }
    }

    // Helper to constrain movement along the fixed red line
    func calculateOffset(value: DragGesture.Value, lineStart: CGFloat, lineEnd: CGFloat) -> CGFloat {
        let dragY = value.location.y
        return max(min(dragY, lineEnd), lineStart) - lineStart
    }

    // Helper to constrain movement along the fixed red line
    func calculateOffsetAlongLine(value: DragGesture.Value, lineStart: CGFloat, lineEnd: CGFloat) -> CGFloat {
        let dragY = value.location.y
        return max(min(dragY, lineEnd), lineStart) - lineStart
    }
}

struct ImageView: View {
    let imageName: String
    let circleColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(circleColor)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        }
    }
}
