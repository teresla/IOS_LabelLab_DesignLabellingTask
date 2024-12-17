import Foundation

@MainActor
class LabellingTaskProvider {
    static func allTasks(for category: String) -> [any LabellingTask] {
        // Filter tasks based on the category
        switch category {
        case "Watches":
            return [
                DistancesTask(category: category),
                ImageToTextTask(category: category),
                TextDistanceTask(category: category)
            ]
        case "Furniture":
            return [
                DistancesTask(category: category),
                ImageToTextTask(category: category),
                TextDistanceTask(category: category)
            ]
        case "Clothes":
            return [
                DistancesTask(category: category),
                ImageToTextTask(category: category),
                TextDistanceTask(category: category)
            ]
        default:
            return []
        }
    }
}
