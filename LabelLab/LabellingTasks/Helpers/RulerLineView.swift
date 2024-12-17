import SwiftUI

struct RulerLineView: View {
    let startLeft: CGPoint
    let endLeft: CGPoint
    let startRight: CGPoint
    let endRight: CGPoint
    let lineThickness: CGFloat
    let tickCount: Int = 10 // Number of ticks

    var body: some View {
        Path { path in
            path.move(to: startLeft)
            path.addLine(to: endLeft)

            path.move(to: startRight)
            path.addLine(to: endRight)
        }
        .stroke(Color.black, lineWidth: lineThickness)

        // Ticks for left and right lines
        ForEach(0...tickCount, id: \.self) { i in
            let t = CGFloat(i) / CGFloat(tickCount)
            let leftTick = CGPoint(
                x: lerp(startLeft.x, endLeft.x, t),
                y: lerp(startLeft.y, endLeft.y, t)
            )
            let rightTick = CGPoint(
                x: lerp(startRight.x, endRight.x, t),
                y: lerp(startRight.y, endRight.y, t)
            )

            Group {
                Path { path in
                    path.move(to: leftTick.offset(by: -5, perpendicularTo: startLeft, endPoint: endLeft))
                    path.addLine(to: leftTick.offset(by: 5, perpendicularTo: startLeft, endPoint: endLeft))
                }
                .stroke(Color.gray, lineWidth: lineThickness)

                Path { path in
                    path.move(to: rightTick.offset(by: -5, perpendicularTo: startRight, endPoint: endRight))
                    path.addLine(to: rightTick.offset(by: 5, perpendicularTo: startRight, endPoint: endRight))
                }
                .stroke(Color.gray, lineWidth: lineThickness)
            }
        }

        // Endpoints
        ForEach([startLeft, endLeft, startRight, endRight], id: \.self) { point in
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .position(x: point.x, y: point.y)
        }
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        return a + (b - a) * t
    }
}

extension CGPoint {
    func offset(by distance: CGFloat, perpendicularTo startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let magnitude = sqrt(dx * dx + dy * dy)
        let normalized = CGPoint(x: -dy / magnitude, y: dx / magnitude)
        return CGPoint(x: self.x + normalized.x * distance, y: self.y + normalized.y * distance)
    }
}
