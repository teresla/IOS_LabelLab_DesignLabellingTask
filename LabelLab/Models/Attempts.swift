//
//  DistanceAttempt.swift
//  LabelLab
//
//  Created by Teresa Windlin on 20.11.2024.
//

import Foundation
import SwiftData

@Model
class DistanceAttempt: Codable {
    var id: UUID = UUID()
    var userId: UUID
    var image1Name: String
    var image2Name: String // New property for Image 2
    var image3Name: String // New property for Image 3
    var distance1_2: Double
    var distance1_3: Double
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        image1Name: String,
        image2Name: String, // Initialize with Image 2
        image3Name: String, // Initialize with Image 3
        distance1_2: Double,
        distance1_3: Double,
        timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.image1Name = image1Name
        self.image2Name = image2Name // Assign Image 2
        self.image3Name = image3Name // Assign Image 3
        self.distance1_2 = distance1_2
        self.distance1_3 = distance1_3
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case image1Name
        case image2Name // New key
        case image3Name // New key
        case distance1_2
        case distance1_3
        case timestamp
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        image1Name = try container.decode(String.self, forKey: .image1Name)
        image2Name = try container.decode(String.self, forKey: .image2Name) // Decode Image 2
        image3Name = try container.decode(String.self, forKey: .image3Name) // Decode Image 3
        distance1_2 = try container.decode(Double.self, forKey: .distance1_2)
        distance1_3 = try container.decode(Double.self, forKey: .distance1_3)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(image1Name, forKey: .image1Name)
        try container.encode(image2Name, forKey: .image2Name) // Encode Image 2
        try container.encode(image3Name, forKey: .image3Name) // Encode Image 3
        try container.encode(distance1_2, forKey: .distance1_2)
        try container.encode(distance1_3, forKey: .distance1_3)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

@Model
class ImageToTextAttempt: Codable {
    var id: UUID = UUID()
    var userId: UUID
    var imageName: String
    var text: String
    var confirmation: Int = 0
    var timestamp: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        imageName: String,
        text: String,
        confirmation: Int = 0,
        timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.imageName = imageName
        self.text = text
        self.confirmation = confirmation
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case imageName
        case text
        case confirmation
        case timestamp
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        imageName = try container.decode(String.self, forKey: .imageName)
        text = try container.decode(String.self, forKey: .text)
        confirmation = try container.decode(Int.self, forKey: .confirmation)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(text, forKey: .text)
        try container.encode(confirmation, forKey: .confirmation)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

