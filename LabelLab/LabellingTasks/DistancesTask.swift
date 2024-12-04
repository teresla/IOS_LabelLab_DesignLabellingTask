import SwiftUI

struct DistancesTask: LabellingTask {
    let id = UUID()
    let title: String = "Image Similarity Task"
    let description: String = "Drag the images along the lines to show their similarity to the center image."
    let titelImage: Image = Image(systemName: "arrow.left.and.right")

    @StateObject private var logic = DistancesTaskLogic()
    @Environment(TaskState.self) private var taskState

    var body: some View {
        GeometryReader { geometry in
            // Naming conventions
            let XAnker = geometry.size.width / 2
            let YAnker = geometry.size.height * 0.6
            let XOffset = geometry.size.width / 4
            let YOffset = geometry.size.height * 0.5
            let endYOffset = geometry.size.height * 0.2
            let imageSize = geometry.size.width * 0.28

            VStack(spacing: 20) {
                Spacer()

                // Interactive content: Lines and images above the buttons
                ZStack {
                    // Fixed Lines
                    Path { path in
                        // Left Line
                        path.move(to: CGPoint(x: XAnker - XOffset, y: YAnker - YOffset))
                        path.addLine(to: CGPoint(x: XAnker - (imageSize/2), y: YAnker - endYOffset))

                        // Right Line
                        path.move(to: CGPoint(x: XAnker + XOffset, y: YAnker - YOffset))
                        path.addLine(to: CGPoint(x: XAnker + (imageSize/2), y: YAnker - endYOffset))
                    }
                    .stroke(Color.white, lineWidth: 3) // Red, fixed lines

                    // Images
                    ZStack {
                        // Center Image (Image 1)
                        ImageView(imageName: logic.image1, circleColor: .red)
                            .frame(width: imageSize, height: imageSize)
                            .scaleEffect(logic.isImage1Held ? 3 : 2.0)
                            .animation(.easeInOut(duration: 0.2), value: logic.isImage1Held)
                            .position(x: XAnker, y: YAnker)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage1Held = true
                                }
                            }

                        // Image 2 (Left)
                        ImageView(imageName: logic.image2, circleColor: .orange)
                            .frame(width: imageSize, height: imageSize)
                            .scaleEffect(logic.isImage2Held ? 3 : 
                                        (logic.isDragging2 || logic.isDragging3) ? 0.6 : 1.5)
                            .animation(.easeInOut(duration: 0.2), value: logic.isImage2Held)
                            .animation(.easeInOut(duration: 0.2), value: logic.isDragging2)
                            .animation(.easeInOut(duration: 0.2), value: logic.isDragging3)
                            .position(
                                x: XAnker - XOffset + logic.image2Offset.width,
                                y: YAnker - YOffset + logic.image2Offset.height
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage2Held = true
                                    logic.isImage3Held = false
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            logic.isDragging2 = true
                                            logic.isImage2Held = false
                                            logic.isImage1Held = false
                                        }
                                        logic.image2Offset = calculateOffsetAlongLine(
                                            value: value,
                                            startPoint: CGPoint(x: XAnker - XOffset, y: YAnker - YOffset),
                                            endPoint: CGPoint(x: XAnker - (imageSize/2), y: YAnker - endYOffset)
                                        )
                                    }
                                    .onEnded { _ in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            logic.isDragging2 = false
                                        }
                                    }
                            )

                        // Image 3 (Right)
                        ImageView(imageName: logic.image3, circleColor: .cyan)
                            .frame(width: imageSize, height: imageSize)
                            .scaleEffect(logic.isImage3Held ? 3 : 
                                        (logic.isDragging2 || logic.isDragging3) ? 0.6 : 1.5)
                            .animation(.easeInOut(duration: 0.2), value: logic.isImage3Held)
                            .animation(.easeInOut(duration: 0.2), value: logic.isDragging2)
                            .animation(.easeInOut(duration: 0.2), value: logic.isDragging3)
                            .position(
                                x: XAnker + XOffset + logic.image3Offset.width,
                                y: YAnker - YOffset + logic.image3Offset.height
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage3Held = true
                                    logic.isImage2Held = false
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            logic.isDragging3 = true
                                            logic.isImage3Held = false
                                            logic.isImage1Held = false
                                        }
                                        logic.image3Offset = calculateOffsetAlongLine(
                                            value: value,
                                            startPoint: CGPoint(x: XAnker + XOffset, y: YAnker - YOffset),
                                            endPoint: CGPoint(x: XAnker + (imageSize/2), y: YAnker - endYOffset)
                                        )
                                    }
                                    .onEnded { _ in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            logic.isDragging3 = false
                                        }
                                    }
                            )
                    }
                }
                .padding(.bottom, 20) // Space above buttons

                Spacer()

                // Buttons for Reshuffle and Confirm
                HStack(spacing: 20) {
                    // Reshuffle Button
                    Button(action: { logic.reshuffleImages() }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: geometry.size.width * 0.35, height: 50)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color(.sRGB, white: 0, opacity: 0.2), radius: 5, x: 0, y: 3)
                    }

                    // Confirm Button
                    Button(action: { logic.saveDistances() }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: geometry.size.width * 0.35, height: 50)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color(.sRGB, white: 0, opacity: 0.2), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20) // Ensure padding with safe area
            }
            .onTapGesture {
                // Reset all images when tapping anywhere
                withAnimation(.easeInOut(duration: 0.2)) {
                    logic.isImage1Held = false
                    logic.isImage2Held = false
                    logic.isImage3Held = false
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // Helper to constrain movement along the fixed red line
    func calculateOffset(value: DragGesture.Value, lineStart: CGFloat, lineEnd: CGFloat) -> CGFloat {
        let dragY = value.location.y
        return max(min(dragY, lineEnd), lineStart) - lineStart
    }

    // Helper to constrain movement along the fixed red line
    func calculateOffsetAlongLine(value: DragGesture.Value, startPoint: CGPoint, endPoint: CGPoint) -> CGSize {
        let dragPoint = value.location
        
        // Calculate the vector of the line
        let lineVector = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
        
        // Project the drag point onto the line
        let dragVector = CGPoint(x: dragPoint.x - startPoint.x, y: dragPoint.y - startPoint.y)
        
        // Calculate the projection scalar
        let lineLength = sqrt(lineVector.x * lineVector.x + lineVector.y * lineVector.y)
        let dotProduct = dragVector.x * lineVector.x + dragVector.y * lineVector.y
        var t = dotProduct / (lineLength * lineLength)
        
        // Clamp t between 0 and 1 to keep the point on the line segment
        t = max(0, min(1, t))
        
        // Calculate the projected point
        let projectedX = lineVector.x * t
        let projectedY = lineVector.y * t
        
        return CGSize(width: projectedX, height: projectedY)
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

#Preview {
    DistancesTask()
        .environment(TaskState())
        .preferredColorScheme(.dark)
}



