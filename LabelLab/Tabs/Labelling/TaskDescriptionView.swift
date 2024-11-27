import SwiftUI

struct TaskDescriptionView: View {
    @Environment(TaskState.self) private var taskState // Injected environment object
    let task: any LabellingTask

    var body: some View {
        @Bindable var taskState = taskState // Make TaskState bindable for dynamic updates

        ScrollView {
            VStack(spacing: 20) {
                task.titelImage
                    .resizable()
                    .frame(width: 80, height: 80)

                Text(task.title)
                    .font(.headline)

                Text(task.description)
                    .multilineTextAlignment(.center)
                    .padding()

                // Start Task Button
                Button(action: {
                    taskState.startTask(task)
                }) {
                    Label("Start Task", systemImage: "play")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 35.0)
                                .fill(Color.blue)
                                .shadow(radius: 10)
                        }
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $taskState.current) { currentTask in
            NavigationStack {
                AnyView(erasing: currentTask.task)
                    .toolbar {
                        Button("Cancel") {
                            taskState.finish(successful: false)
                        }
                    }
            }
        }
    }
}
