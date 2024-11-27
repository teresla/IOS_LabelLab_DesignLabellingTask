//
//  User.swift
//  LabelLab
//
//  Created by Teresa Windlin on 20.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class User: Codable {
    var id: UUID
    var username: String
    var labellerCode: String? // Optional labeller code
    var categories: [String]
    var isDarkModeEnabled: Bool

    init(username: String, labellerCode: String? = nil, categories: [String] = [], isDarkModeEnabled: Bool = false) {
        self.id = UUID()
        self.username = username.lowercased()
        self.labellerCode = labellerCode
        self.categories = categories
        self.isDarkModeEnabled = isDarkModeEnabled
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case labellerCode
        case categories
        case isDarkModeEnabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username).lowercased()
        categories = try container.decode([String].self, forKey: .categories)
        labellerCode = try container.decodeIfPresent(String.self, forKey: .labellerCode)
        isDarkModeEnabled = try container.decode(Bool.self, forKey: .isDarkModeEnabled)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username.lowercased(), forKey: .username)
        try container.encode(categories, forKey: .categories)
        try container.encodeIfPresent(labellerCode, forKey: .labellerCode)
        try container.encode(isDarkModeEnabled, forKey: .isDarkModeEnabled)
    }
}
