//
//  UserSettings.swift
//  LabelLab
//
//  Created by Teresa Windlin on 18.11.2024.
//

import Foundation
import SwiftUI

@Observable class UserSettings {
    static let shared = UserSettings()
    
    private init() {}

    static let userDefaultsKeyName = "levels.user-settings.name"
    static let userDefaultsKeyNickname = "levels.user.settings.nickname"
    static let userDefaultsKeyUserId = "levels.user-settings.userId"

    var name: String {
        get {
            UserDefaults.standard.string(forKey: Self.userDefaultsKeyName) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKeyName)
        }
    }

    var nickname: String {
        get {
            UserDefaults.standard.string(forKey: Self.userDefaultsKeyNickname) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKeyNickname)
        }
    }

    var userId: UUID {
        UserDefaults.standard.string(forKey: Self.userDefaultsKeyUserId)
            .flatMap { UUID(uuidString: $0) }
        ?? {
            let uuid = UUID()
            UserDefaults.standard.set(uuid.uuidString, forKey: Self.userDefaultsKeyUserId)
            return uuid
        }()
    }

    var alwaysUseDarkMode = false

    var withPayment = false
}
