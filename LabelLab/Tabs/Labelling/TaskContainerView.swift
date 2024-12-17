import SwiftUI

struct TaskContainerView<Content: View>: View {
    let taskTitle: String
    let onSubmit: () -> Void
    let onReshuffle: () -> Void
    let content: Content

    @Environment(\.presentationMode) private var presentationMode

    init(taskTitle: String, onSubmit: @escaping () -> Void, onReshuffle: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.taskTitle = taskTitle
        self.onSubmit = onSubmit
        self.onReshuffle = onReshuffle
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Navigation (X button + Title)
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "xmark").foregroundColor(.red))
                    }
                    Spacer()
                    Text(taskTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()

                // Task-specific content
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom Buttons
                HStack(spacing: 40) {
                    Button(action: onReshuffle) {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay(Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(.blue))
                    }

                    Button(action: onSubmit) {
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay(Image(systemName: "checkmark").foregroundColor(.green))
                    }
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
