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
        print("Started task: \(task.title)") // Debugging log

    }

    func finish(successful: Bool) {
        guard let current else { return }

        let elapsedTime = Date().timeIntervalSince(current.start)

        print("Task '\(current.task.title)' completed. Successful: \(successful). Time taken: \(elapsedTime) seconds.")

        self.current = nil
    }
}
