import SwiftUI

struct DistanceBaseView<CenterContent: View, LeftContent: View, RightContent: View>: View {
    @Binding var leftOffset: CGSize
    @Binding var rightOffset: CGSize
    @Binding var enlargedIndex: Int?

    let lineThickness: CGFloat
    let centerContent: () -> any View
    let leftContent: () -> any View
    let rightContent: () -> any View


    @State private var isDraggingLeft: Bool = false
    @State private var isDraggingRight: Bool = false

    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        GeometryReader { geometry in
            let XAnchor = geometry.size.width / 2
            let YAnchor = geometry.size.height * 0.85
            let XOffset = geometry.size.width / 4
            let YOffset = geometry.size.height * 0.7
            let endYOffset = geometry.size.height * 0.15

            let baseSize = geometry.size.width * 0.4
            let zoomedSize = baseSize * 1.5
            let draggedSize = baseSize * 0.6

            // Ruler Lines
            Path { path in
                let leftStart = CGPoint(x: XAnchor - XOffset, y: YAnchor - YOffset)
                let leftEnd = CGPoint(x: XAnchor - baseSize / 2, y: YAnchor - endYOffset)
                let rightStart = CGPoint(x: XAnchor + XOffset, y: YAnchor - YOffset)
                let rightEnd = CGPoint(x: XAnchor + baseSize / 2, y: YAnchor - endYOffset)

                path.move(to: leftStart)
                path.addLine(to: leftEnd)

                path.move(to: rightStart)
                path.addLine(to: rightEnd)
            }
            .stroke(Color.black, lineWidth: lineThickness)

            // Dots at line ends
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .position(x: XAnchor - XOffset, y: YAnchor - YOffset)
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .position(x: XAnchor - baseSize / 2, y: YAnchor - endYOffset)
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .position(x: XAnchor + XOffset, y: YAnchor - YOffset)
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .position(x: XAnchor + baseSize / 2, y: YAnchor - endYOffset)

            // Center Image
            AnyView(centerContent())
                .frame(
                    width: enlargedIndex == 1 ? zoomedSize : baseSize, // Use zoomedSize when enlarged
                    height: enlargedIndex == 1 ? zoomedSize : baseSize
                )
                //.scaleEffect(enlargedIndex == 1 ? 1.5 : 1.0) // Adjust zoom scale here
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("AccentBlue"), lineWidth: 4))
                .position(x: XAnchor, y: YAnchor)
                .onTapGesture {
                    withAnimation {
                        enlargedIndex = enlargedIndex == 1 ? nil : 1
                    }
                }


            // Left Image
            AnyView(leftContent())
                .frame(width: isDraggingLeft || isDraggingRight ? draggedSize : (enlargedIndex == 2 ? zoomedSize : baseSize),
                           height: isDraggingLeft || isDraggingRight ? draggedSize : (enlargedIndex == 2 ? zoomedSize : baseSize))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("AccentOrange"), lineWidth: 4))
                .position(
                    x: XAnchor - XOffset + leftOffset.width,
                    y: YAnchor - YOffset + leftOffset.height
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingLeft = true
                            enlargedIndex = nil
                            hapticFeedback.impactOccurred()
                            leftOffset = GeometryHelpers.offsetAlongLine(
                                value: value,
                                startPoint: CGPoint(x: XAnchor - XOffset, y: YAnchor - YOffset),
                                endPoint: CGPoint(x: XAnchor - baseSize / 2, y: YAnchor - endYOffset)
                            )
                        }
                        .onEnded { _ in isDraggingLeft = false }
                )
                .onTapGesture {
                    withAnimation {
                        if enlargedIndex == 3 { // Right is enlarged -> shrink Right and enlarge Left
                            enlargedIndex = 2
                        } else if enlargedIndex == 2 { // Left is already enlarged -> shrink Left
                            enlargedIndex = nil
                        } else { // Enlarge Left
                            enlargedIndex = 2
                        }
                    }
                }



            // Right Image
            AnyView(rightContent())
                .frame(width: isDraggingLeft || isDraggingRight ? draggedSize : (enlargedIndex == 3 ? zoomedSize : baseSize),
                       height: isDraggingLeft || isDraggingRight ? draggedSize : (enlargedIndex == 3 ? zoomedSize : baseSize))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("AccentGreen"), lineWidth: 4))
                .position(
                    x: XAnchor + XOffset + rightOffset.width,
                    y: YAnchor - YOffset + rightOffset.height
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingRight = true
                            enlargedIndex = nil
                            hapticFeedback.impactOccurred()
                            rightOffset = GeometryHelpers.offsetAlongLine(
                                value: value,
                                startPoint: CGPoint(x: XAnchor + XOffset, y: YAnchor - YOffset),
                                endPoint: CGPoint(x: XAnchor + baseSize / 2, y: YAnchor - endYOffset)
                            )
                        }
                        .onEnded { _ in isDraggingRight = false }
                )
                .onTapGesture {
                    withAnimation {
                        if enlargedIndex == 2 { // Left is enlarged -> shrink Left and enlarge Right
                            enlargedIndex = 3
                        } else if enlargedIndex == 3 { // Right is already enlarged -> shrink Right
                            enlargedIndex = nil
                        } else { // Enlarge Right
                            enlargedIndex = 3
                        }
                    }
                }


        }
    }
}
