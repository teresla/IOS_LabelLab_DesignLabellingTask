//
//  LabelLabApp.swift
//  LabelLab
//
//  Created by Teresa Windlin on 19.11.2024.
//

import SwiftUI

@main
struct LabelLabApp: App {
    @State private var userSettings = UserSettings.shared
    @State private var taskState = TaskState()
    @State private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(userSettings)
                .environment(taskState)
                .modelContainer(SwiftDataManager.shared.modelContainer)
                .preferredColorScheme(userSettings.alwaysUseDarkMode ? .dark : nil)        }
    }
}
