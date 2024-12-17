//
//  GeometryHelpers.swift
//  LabelLab
//
//  Created by Teresa Windlin on 15.12.2024.
//


import SwiftUI

struct GeometryHelpers {
    /// Constrains movement along a line defined by startPoint and endPoint.
    static func offsetAlongLine(value: DragGesture.Value, startPoint: CGPoint, endPoint: CGPoint) -> CGSize {
        let dragPoint = value.location
        let lineVector = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
        let dragVector = CGPoint(x: dragPoint.x - startPoint.x, y: dragPoint.y - startPoint.y)
        let lineLength = sqrt(lineVector.x * lineVector.x + lineVector.y * lineVector.y)
        let dotProduct = dragVector.x * lineVector.x + dragVector.y * lineVector.y
        let t = max(0, min(1, dotProduct / (lineLength * lineLength)))
        return CGSize(width: lineVector.x * t, height: lineVector.y * t)
    }

    /// Normalizes a CGSize offset into a distance value.
    static func normalizedDistance(_ offset: CGSize, scale: Double = 200.0) -> Double {
        let magnitude = sqrt(pow(Double(offset.width), 2) + pow(Double(offset.height), 2))
        return magnitude / scale
    }
}
