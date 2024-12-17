import SwiftUI

struct TaskListView: View {
    @State private var selectedCategory: String = "Watches"
    @State private var expandedTaskID: UUID? = nil
    private let categories = ["Watches", "Furniture", "Clothes"]
    private let categoryColors: [String: Color] = [
        "Watches": Color("AccentBlue"),
        "Furniture": Color("AccentOrange"),
        "Clothes": Color("AccentGreen")
    ]

    let onStartTask: (any LabellingTask) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Category Selector
            Text("Categories")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.leading, 16)
                .padding(.top, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            withAnimation {
                                selectedCategory = category
                            }
                        }) {
                            Text(category)
                                .font(.subheadline)
                                .fontWeight(selectedCategory == category ? .bold : .regular)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .foregroundColor(selectedCategory == category ? .white : .black)
                                .background(selectedCategory == category ? categoryColors[category] : Color.gray.opacity(0.2))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Task List
            Text("Labelling Tasks")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.leading, 16)
                .padding(.top, 10)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(LabellingTaskProvider.allTasks(for: selectedCategory), id: \.id) { task in
                        MainItemView(
                            task: task,
                            expandedTaskID: $expandedTaskID,
                            selectedCategory: $selectedCategory,
                            onStartTask: onStartTask
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
        }
    }
}
