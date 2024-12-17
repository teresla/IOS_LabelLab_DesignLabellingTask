import SwiftUI

struct TaskRunnerView: View {
    let task: any LabellingTask

    init(task: any LabellingTask) {
        self.task = task
    }

    var body: some View {
        VStack {
            task.typeErasedBody
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("Started task: \(task.title)")
        }
        .onDisappear {
            print("Finished task: \(task.title)")
        }
    }
}
