import SwiftUI
import UIKit

struct DistancesTask: LabellingTask {
    let id = UUID()
    let title: String = "Image Similarity Task"
    let description: String = "Drag the images along the lines to show their similarity to the center image."
    let titelImage: Image = Image(systemName: "arrow.left.and.right")

    @StateObject private var logic = DistancesTaskLogic()
    @Environment(TaskState.self) private var taskState
    @Environment(\.colorScheme) private var colorScheme
    @State private var lastTappedImage: Int = 0
    @State private var lastFeedbackPosition2: CGPoint?
    @State private var lastFeedbackPosition3: CGPoint?
    private let feedbackThreshold: CGFloat = 20.0

    private let lineThickness: CGFloat = 3.0
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)

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
                    // Fixed Lines with Ticks
                    Path { path in
                        // Left Line
                        let leftStart = CGPoint(x: XAnker - XOffset, y: YAnker - YOffset)
                        let leftEnd = CGPoint(x: XAnker - (imageSize/2), y: YAnker - endYOffset)
                        drawRulerLine(path: &path, start: leftStart, end: leftEnd)

                        // Right Line
                        let rightStart = CGPoint(x: XAnker + XOffset, y: YAnker - YOffset)
                        let rightEnd = CGPoint(x: XAnker + (imageSize/2), y: YAnker - endYOffset)
                        drawRulerLine(path: &path, start: rightStart, end: rightEnd)
                    }
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: lineThickness)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

                    // Endpoint Dots
                    Circle()
                        .fill(colorScheme == .dark ? Color.white : Color.black)
                        .frame(width: 16, height: 16)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .position(x: XAnker - XOffset, y: YAnker - YOffset)
                    Circle()
                        .fill(colorScheme == .dark ? Color.white : Color.black)
                        .frame(width: 16, height: 16)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .position(x: XAnker - (imageSize/2), y: YAnker - endYOffset)
                    Circle()
                        .fill(colorScheme == .dark ? Color.white : Color.black)
                        .frame(width: 16, height: 16)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .position(x: XAnker + XOffset, y: YAnker - YOffset)
                    Circle()
                        .fill(colorScheme == .dark ? Color.white : Color.black)
                        .frame(width: 16, height: 16)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .position(x: XAnker + (imageSize/2), y: YAnker - endYOffset)

                    // Images
                    ZStack {
                        // Center Image (Image 1)
                        ImageView(imageName: logic.image1, circleColor: .red)
                            .frame(width: imageSize, height: imageSize)
                            .scaleEffect(logic.isImage1Held ? 3 : 2.0)
                            .animation(.easeInOut(duration: 0.2), value: logic.isImage1Held)
                            .position(x: XAnker, y: YAnker)
                            .zIndex(lastTappedImage == 1 ? 3 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage1Held = true
                                    lastTappedImage = 1
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
                            .zIndex(lastTappedImage == 2 ? 3 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage2Held = true
                                    logic.isImage3Held = false
                                    lastTappedImage = 2
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
                                        
                                        // Calculate distance moved
                                        if let lastPosition = lastFeedbackPosition2 {
                                            let distance = hypot(value.location.x - lastPosition.x, value.location.y - lastPosition.y)
                                            if distance > feedbackThreshold {
                                                hapticFeedback.impactOccurred()
                                                lastFeedbackPosition2 = value.location
                                            }
                                        } else {
                                            lastFeedbackPosition2 = value.location
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
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        lastFeedbackPosition2 = nil
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
                            .zIndex(lastTappedImage == 3 ? 3 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    logic.isImage3Held = true
                                    logic.isImage2Held = false
                                    lastTappedImage = 3
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
                                        
                                        // Calculate distance moved
                                        if let lastPosition = lastFeedbackPosition3 {
                                            let distance = hypot(value.location.x - lastPosition.x, value.location.y - lastPosition.y)
                                            if distance > feedbackThreshold {
                                                hapticFeedback.impactOccurred()
                                                lastFeedbackPosition3 = value.location
                                            }
                                        } else {
                                            lastFeedbackPosition3 = value.location
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
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        lastFeedbackPosition3 = nil
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
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }

                    // Confirm Button
                    Button(action: { logic.saveDistances() }) {
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
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

    private func drawRulerLine(path: inout Path, start: CGPoint, end: CGPoint) {
        // Main line
        path.move(to: start)
        path.addLine(to: end)
        
        // Calculate line angle and length
        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)
        
        // Number of ticks
        let majorTickCount = 5
        let minorTicksPerMajor = 5
        
        // Tick lengths
        let majorTickLength: CGFloat = 15
        let minorTickLength: CGFloat = 10
        
        // Draw ticks
        for i in 0...majorTickCount {
            let progress = CGFloat(i) / CGFloat(majorTickCount)
            let x = start.x + dx * progress
            let y = start.y + dy * progress
            
            // Major tick
            let perpX = -sin(angle) * majorTickLength / 2
            let perpY = cos(angle) * majorTickLength / 2
            
            path.move(to: CGPoint(x: x - perpX, y: y - perpY))
            path.addLine(to: CGPoint(x: x + perpX, y: y + perpY))
            
            // Minor ticks
            if i < majorTickCount {
                for j in 1..<minorTicksPerMajor {
                    let minorProgress = progress + (CGFloat(j) / CGFloat(minorTicksPerMajor)) * (1.0 / CGFloat(majorTickCount))
                    let minorX = start.x + dx * minorProgress
                    let minorY = start.y + dy * minorProgress
                    
                    let minorPerpX = -sin(angle) * minorTickLength / 2
                    let minorPerpY = cos(angle) * minorTickLength / 2
                    
                    path.move(to: CGPoint(x: minorX - minorPerpX, y: minorY - minorPerpY))
                    path.addLine(to: CGPoint(x: minorX + minorPerpX, y: minorY + minorPerpY))
                }
            }
        }
    }
}

struct ImageView: View {
    let imageName: String
    let circleColor: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Add shadow behind the entire component
            Circle()
                .fill(circleColor)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            Circle()
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    DistancesTask()
        .environment(TaskState())
        .preferredColorScheme(.light)
}



