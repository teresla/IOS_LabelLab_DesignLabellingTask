//
//  SwiftDataManager.swift
//  LabelLab
//
//  Created by Teresa Windlin on 20.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let modelContainer: ModelContainer
    
    private init() {
        do {
            self.modelContainer = try ModelContainer(
                for: User.self,
                DistanceAttempt.self,
                ImageToTextAttempt.self,
                TextDistanceAttempt.self // Added new model
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - DistanceAttempt
    func saveDistanceAttempt(_ attempt: DistanceAttempt, username: String) {
        print("Saving DistanceAttempt: ID = \(attempt.id), Username = \(username)")
        let attempt = attempt
        attempt.username = username // Associate with username
        modelContainer.mainContext.insert(attempt)
        do {
            try modelContainer.mainContext.save()
            print("Successfully saved DistanceAttempt: \(attempt)")
        } catch {
            print("Error saving DistanceAttempt: \(error)")
        }
    }

    
    func fetchDistanceAttempts(forUsername username: String) -> [DistanceAttempt] {
        let fetchDescriptor = FetchDescriptor<DistanceAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            return attempts.filter { $0.username == username }
        } catch {
            print("Error fetching DistanceAttempts: \(error)")
            return []
        }
    }
    
    // MARK: - ImageToTextAttempt
    func saveImageToTextAttempt(_ attempt: ImageToTextAttempt, username: String) {
        let attempt = attempt
        attempt.username = username // Associate with username
        modelContainer.mainContext.insert(attempt)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving ImageToTextAttempt: \(error)")
        }
    }
    
    func fetchImageToTextAttempts(forUsername username: String) -> [ImageToTextAttempt] {
        let fetchDescriptor = FetchDescriptor<ImageToTextAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            return attempts.filter { $0.username == username }
        } catch {
            print("Error fetching ImageToTextAttempts: \(error)")
            return []
        }
    }
    
    // MARK: - TextDistanceAttempt (NEW)
    func saveTextDistanceAttempt(_ attempt: TextDistanceAttempt, username: String) {
        let attempt = attempt
        attempt.username = username // Associate with username
        modelContainer.mainContext.insert(attempt)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving TextDistanceAttempt: \(error)")
        }
    }
    
    func fetchTextDistanceAttempts(forUsername username: String) -> [TextDistanceAttempt] {
        let fetchDescriptor = FetchDescriptor<TextDistanceAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            return attempts.filter { $0.username == username }
        } catch {
            print("Error fetching TextDistanceAttempts: \(error)")
            return []
        }
    }
    
    // MARK: - User Management
    func saveUser(_ user: User) {
        modelContainer.mainContext.insert(user)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    func fetchAllUsers() -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        do {
            return try modelContainer.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }
    
    func updateUser(index: Int, update: (inout User) -> Void) {
        var users = fetchAllUsers()
        update(&users[index])
        saveUser(users[index])
    }
    
    func registerNewUser(username: String, categories: [String] = ["Watches"], linkedinLink: String? = nil) {
        // Create a new user
        let newUser = User(username: username, linkedinLink: linkedinLink)

        // Save the new user to SwiftData
        SwiftDataManager.shared.saveUser(newUser)

        // Automatically update UserSettings with the new user's details
        UserSettings.shared.username = newUser.username
        UserSettings.shared.id = newUser.id
        
        print("User registered: \(newUser.username), \(newUser.id.uuidString), LinkedIn: \(newUser.linkedinLink ?? "None")")
    }

    
    func isUsernameTaken(_ username: String) -> Bool {
        let normalizedUsername = username.lowercased()
        return fetchAllUsers().contains { $0.username == normalizedUsername }
    }
    
    // Debugging added for fetchAllDistanceAttempts
    func fetchAllDistanceAttempts() -> [DistanceAttempt] {
        print("Fetching all DistanceAttempts...")
        let fetchDescriptor = FetchDescriptor<DistanceAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            print("Fetched DistanceAttempts: \(attempts.map { $0.id.uuidString })")
            return attempts
        } catch {
            print("Error fetching DistanceAttempts: \(error)")
            return []
        }
    }
    
    // Debugging added for fetchAllImageToTextAttempts
    func fetchAllImageToTextAttempts() -> [ImageToTextAttempt] {
        print("Fetching all ImageToTextAttempts...")
        let fetchDescriptor = FetchDescriptor<ImageToTextAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            print("Fetched ImageToTextAttempts: \(attempts.map { $0.id.uuidString })")
            return attempts
        } catch {
            print("Error fetching ImageToTextAttempts: \(error)")
            return []
        }
    }
    
    // Debugging added for fetchAllTextDistanceAttempts
    func fetchAllTextDistanceAttempts() -> [TextDistanceAttempt] {
        print("Fetching all TextDistanceAttempts...")
        let fetchDescriptor = FetchDescriptor<TextDistanceAttempt>()
        do {
            let attempts = try modelContainer.mainContext.fetch(fetchDescriptor)
            print("Fetched TextDistanceAttempts: \(attempts.map { $0.id.uuidString })")
            return attempts
        } catch {
            print("Error fetching TextDistanceAttempts: \(error)")
            return []
        }
    }
}
