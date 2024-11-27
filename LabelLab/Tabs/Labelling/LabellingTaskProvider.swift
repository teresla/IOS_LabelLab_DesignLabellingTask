//
//  LabellingTask.swift
//  LabelLab
//
//  Created by Teresa Windlin on 13.11.2024.
//

@MainActor
class LabellingTaskProvider {
    static let allTasks: [any LabellingTask] = [
        DistancesTask(),
        ImageToTextTask(),
        ImageToWhichTextTask()
    ]
}
