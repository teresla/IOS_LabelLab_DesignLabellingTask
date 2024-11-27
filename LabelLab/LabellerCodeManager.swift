//
//  LabellerCodeManager.swift
//  LabelLab
//
//  Created by Teresa Windlin on 25.11.2024.
//

struct LabellerCode: Codable {
    let code: String
    let categories: [String]
    var isUsed: Bool
}

final class LabellerCodeManager {
    static let shared = LabellerCodeManager()

    private init() {}

    private var codes: [LabellerCode] = [
        LabellerCode(code: "ABC123", categories: ["Watches"], isUsed: false),
        LabellerCode(code: "DEF456", categories: ["Watches"], isUsed: false),
        LabellerCode(code: "GHI789", categories: ["Watches"], isUsed: true)
    ]

    func validateCode(_ code: String) -> (isValid: Bool, categories: [String]?) {
        if let labellerCode = codes.first(where: { $0.code == code && !$0.isUsed }) {
            return (true, labellerCode.categories)
        }
        return (false, nil)
    }

    func markCodeAsUsed(_ code: String) {
        if let index = codes.firstIndex(where: { $0.code == code }) {
            codes[index].isUsed = true
        }
    }
}
