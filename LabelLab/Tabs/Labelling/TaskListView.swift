import SwiftUI

struct TaskListView: View {
    @State private var selectedCategory: String = "Watches" // Default category
    private let categories = ["Watches"] // Categories for horizontal scroll

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Horizontal Category Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                                .fontWeight(selectedCategory == category ? .bold : .regular)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Task List Section
            List {
                ForEach(LabellingTaskProvider.allTasks, id: \.id) { task in
                    NavigationLink(destination: TaskDescriptionView(task: task)) {
                        MainItemView(task: task)
                    }
                }
            }
        }
        .padding(.vertical)
    }
}
