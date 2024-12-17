import SwiftUI

class UserSettings: ObservableObject {
    static let shared = UserSettings()

    @Published var isLoggedIn: Bool = false
    @Published var username: String = "Default"
    @Published var id: UUID = UUID()
    @Published var isAdmin: Bool = false
    @Published var isMonetized: Bool = false

    private init() {}

    func updateForUser(user: User) {
        username = user.username
        id = user.id
        isAdmin = user.isAdmin
        isMonetized = user.isMonetized
        isLoggedIn = true
    }

    func resetToGuest() {
        username = ""
        id = UUID()
        isAdmin = false
        isMonetized = false
        isLoggedIn = false
    }
}
