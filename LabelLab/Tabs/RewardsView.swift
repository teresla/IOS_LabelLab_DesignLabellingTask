//
//  Untitled.swift
//  LabelLab
//
//  Created by Teresa Windlin on 25.11.2024.
//

import SwiftUI
import Charts

struct RewardsView: View {
    let user: User?
    @State private var taskDistribution: [(String, Int)] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Task Rewards")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                if taskDistribution.isEmpty {
                    Text("No task data available.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Chart {
                        ForEach(taskDistribution, id: \.0) { task, count in
                            SectorMark(angle: .value("Count", count))
                                .foregroundStyle(by: .value("Task", task))
                                .cornerRadius(5)
                                .annotation(position: .overlay) {
                                    Text("\(count)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("Rewards")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadTaskData()
        }
    }

    private func loadTaskData() {
        guard let user = user else { return }

        // Fetch all task attempts for the user
        let distanceAttempts = SwiftDataManager.shared.fetchAllDistanceAttempts()
            .filter { $0.userId == user.id }
        let imageToTextAttempts = SwiftDataManager.shared.fetchAllImageToTextAttempts()
            .filter { $0.userId == user.id }

        // Calculate task distribution
        let distanceCount = distanceAttempts.count
        let imageToTextCount = imageToTextAttempts.count

        // Populate distribution
        taskDistribution = [
            ("Distance", distanceCount),
            ("Image to Text", imageToTextCount)
        ]
    }
}
