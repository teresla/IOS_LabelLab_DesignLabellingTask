import SwiftUI

struct MainItemView: View {
    let task: any LabellingTask
    @Binding var expandedTaskID: UUID?
    @Binding var selectedCategory: String
    @State private var navigateToTask: Bool = false
    let onStartTask: (any LabellingTask) -> Void

    private let categoryColors: [String: Color] = [
        "Watches": Color("AccentBlue"),
        "Furniture": Color("AccentOrange"),
        "Clothes": Color("AccentGreen")
    ]

    var isExpanded: Bool {
        expandedTaskID == task.id
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                task.titelImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text(task.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    expandedTaskID = isExpanded ? nil : task.id
                }
            }

            if isExpanded {
                VStack(spacing: 10) {
                    Text(task.description)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    NavigationLink(
                        destination: TaskRunnerView(task: task),
                        isActive: $navigateToTask
                    ) {
                        Button(action: {
                            onStartTask(task)
                            navigateToTask = true
                        }) {
                            Text("Start Task")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(categoryColors[selectedCategory] ?? Color.gray)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 5)
    }
}
