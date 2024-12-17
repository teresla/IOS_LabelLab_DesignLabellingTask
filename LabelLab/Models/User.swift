import Foundation
import SwiftData
import SwiftUI

@Model
class User: Codable {
    var id: UUID
    var username: String
    var isAdmin: Bool
    var isMonetized: Bool
    var linkedinLink: String?

    init(username: String, isMonetized: Bool = false, linkedinLink: String? = nil) {
        self.id = UUID()
        self.username = username.lowercased()
        self.isAdmin = ["luka", "teresa"].contains(username.lowercased())
        self.isMonetized = isMonetized
        self.linkedinLink = linkedinLink
    }

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case isAdmin
        case isMonetized
        case linkedinLink
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username).lowercased()
        isAdmin = try container.decode(Bool.self, forKey: .isAdmin)
        isMonetized = try container.decode(Bool.self, forKey: .isMonetized)
        linkedinLink = try container.decodeIfPresent(String.self, forKey: .linkedinLink)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username.lowercased(), forKey: .username)
        try container.encode(isAdmin, forKey: .isAdmin)
        try container.encode(isMonetized, forKey: .isMonetized)
        try container.encodeIfPresent(linkedinLink, forKey: .linkedinLink)
    }
}
