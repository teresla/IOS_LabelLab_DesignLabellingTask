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
    var username: String // New property for username
    var image1Name: String
    var image2Name: String
    var image3Name: String
    var distance1_2: Double
    var distance1_3: Double
    var timestamp: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        username: String, // Add username
        image1Name: String,
        image2Name: String,
        image3Name: String,
        distance1_2: Double,
        distance1_3: Double,
        timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.username = username // Assign username
        self.image1Name = image1Name
        self.image2Name = image2Name
        self.image3Name = image3Name
        self.distance1_2 = distance1_2
        self.distance1_3 = distance1_3
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case username // New key
        case image1Name
        case image2Name
        case image3Name
        case distance1_2
        case distance1_3
        case timestamp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username) // Decode username
        image1Name = try container.decode(String.self, forKey: .image1Name)
        image2Name = try container.decode(String.self, forKey: .image2Name)
        image3Name = try container.decode(String.self, forKey: .image3Name)
        distance1_2 = try container.decode(Double.self, forKey: .distance1_2)
        distance1_3 = try container.decode(Double.self, forKey: .distance1_3)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(username, forKey: .username) // Encode username
        try container.encode(image1Name, forKey: .image1Name)
        try container.encode(image2Name, forKey: .image2Name)
        try container.encode(image3Name, forKey: .image3Name)
        try container.encode(distance1_2, forKey: .distance1_2)
        try container.encode(distance1_3, forKey: .distance1_3)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

@Model
class ImageToTextAttempt: Codable {
    var id: UUID = UUID()
    var userId: UUID
    var username: String // New property for username
    var imageName: String
    var text: String
    var confirmation: Int = 0
    var timestamp: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        username: String, // Add username
        imageName: String,
        text: String,
        confirmation: Int = 0,
        timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.username = username // Assign username
        self.imageName = imageName
        self.text = text
        self.confirmation = confirmation
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case username // New key
        case imageName
        case text
        case confirmation
        case timestamp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username) // Decode username
        imageName = try container.decode(String.self, forKey: .imageName)
        text = try container.decode(String.self, forKey: .text)
        confirmation = try container.decode(Int.self, forKey: .confirmation)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(username, forKey: .username) // Encode username
        try container.encode(imageName, forKey: .imageName)
        try container.encode(text, forKey: .text)
        try container.encode(confirmation, forKey: .confirmation)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
@Model
class TextDistanceAttempt: Codable {
    var id: UUID = UUID()
    var userId: UUID
    var username: String // New property for username
    var imageName: String
    var text1: String
    var text2: String
    var distanceText1: Double
    var distanceText2: Double
    var timestamp: Date

    init(
        userId: UUID,
        username: String, // Add username
        imageName: String,
        text1: String,
        text2: String,
        distanceText1: Double,
        distanceText2: Double,
        timestamp: Date
    ) {
        self.userId = userId
        self.username = username // Assign username
        self.imageName = imageName
        self.text1 = text1
        self.text2 = text2
        self.distanceText1 = distanceText1
        self.distanceText2 = distanceText2
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case username // New key
        case imageName
        case text1
        case text2
        case distanceText1
        case distanceText2
        case timestamp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username) // Decode username
        imageName = try container.decode(String.self, forKey: .imageName)
        text1 = try container.decode(String.self, forKey: .text1)
        text2 = try container.decode(String.self, forKey: .text2)
        distanceText1 = try container.decode(Double.self, forKey: .distanceText1)
        distanceText2 = try container.decode(Double.self, forKey: .distanceText2)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(username, forKey: .username) // Encode username
        try container.encode(imageName, forKey: .imageName)
        try container.encode(text1, forKey: .text1)
        try container.encode(text2, forKey: .text2)
        try container.encode(distanceText1, forKey: .distanceText1)
        try container.encode(distanceText2, forKey: .distanceText2)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
