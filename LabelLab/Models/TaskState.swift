//
//  TaskState.swift
//  LabelLab
//
//  Created by Teresa Windlin on 20.11.2024.
//

import Foundation
import SwiftUI

@Observable @MainActor
class TaskState {
    struct TaskStart: Identifiable {
        let start: Date
        let task: any LabellingTask
        var id: String {
            task.id.uuidString
        }
    }

    var current: TaskStart?

    func startTask(_ task: any LabellingTask) {
        current = TaskStart(start: Date(), task: task)
    }

    func finish(successful: Bool) {
        guard let current else { return }

        let elapsedTime = Date().timeIntervalSince(current.start)

        // Save attempt logic here (if needed)
        // You could integrate your storage mechanism for tracking completed tasks
        print("Task '\(current.task.title)' completed. Successful: \(successful). Time taken: \(elapsedTime) seconds.")

        self.current = nil
    }
}
/Users/teres/Documents/GitHub/LabelLab/LabelLab/Models
