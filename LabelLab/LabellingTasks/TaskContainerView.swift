import SwiftUI

struct TaskContainerView<TaskContent: View>: View {
    let taskTitle: String // Title of the task
    let taskContent: TaskContent // Task-specific view
    let onSubmit: () -> Void // Submit action
    let onReshuffle: () -> Void // Reshuffle action

    @Environment(\.presentationMode) private var presentationMode // For dismissing

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Navigation Bar
                HStack {
                    // Dismiss Button (X)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                            .frame(width: 40, height: 40)
                            .overlay {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                            }
                    }
                    Spacer()
                    // Task Title
                    Text(taskTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                
                // Task-Specific Content
                taskContent
                    .frame(maxHeight: .infinity) // Expand to fill available space

                // Bottom Buttons
                HStack(spacing: 20) {
                    Button(action: onReshuffle) {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                    }
                    Button(action: onSubmit) {
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                    }
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
