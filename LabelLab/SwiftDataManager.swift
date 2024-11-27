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
            self.modelContainer = try ModelContainer(for: User.self, DistanceAttempt.self, ImageToTextAttempt.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    // Save DistanceAttempt
    func saveDistanceAttempt(_ attempt: DistanceAttempt) {
        modelContainer.mainContext.insert(attempt)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving DistanceAttempt: \(error)")
        }
    }

    // Fetch DistanceAttempts
    func fetchAllDistanceAttempts() -> [DistanceAttempt] {
        let fetchDescriptor = FetchDescriptor<DistanceAttempt>()
        do {
            return try modelContainer.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching DistanceAttempts: \(error)")
            return []
        }
    }

    // Save ImageToTextAttempt
    func saveImageToTextAttempt(_ attempt: ImageToTextAttempt) {
        modelContainer.mainContext.insert(attempt)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving ImageToTextAttempt: \(error)")
        }
    }

    // Fetch ImageToTextAttempts
    func fetchAllImageToTextAttempts() -> [ImageToTextAttempt] {
        let fetchDescriptor = FetchDescriptor<ImageToTextAttempt>()
        do {
            return try modelContainer.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching ImageToTextAttempts: \(error)")
            return []
        }
    }
    
    // Save a new user
    func saveUser(_ user: User) {
        modelContainer.mainContext.insert(user)
        do {
            try modelContainer.mainContext.save()
        } catch {
            print("Error saving user: \(error)")
        }
    }

    // Fetch all users
    func fetchAllUsers() -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        do {
            return try modelContainer.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    // Check if username is taken
    func isUsernameTaken(_ username: String) -> Bool {
        let normalizedUsername = username.lowercased()
        return fetchAllUsers().contains { $0.username == normalizedUsername }
    }
    
    func updateUser(index: Int, update: (inout User) -> Void) {
            var users = fetchAllUsers()
            update(&users[index])
            saveUser(users[index])
        }

}

