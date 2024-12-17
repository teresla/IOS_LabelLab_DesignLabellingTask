import SwiftUI
import Charts
struct RewardsView: View {
    let userId: UUID
    let username: String
    @State private var taskDistribution: [(String, Int)] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Task Rewards")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Text("User: \(username)")
                    .font(.subheadline)
                    .padding(.bottom, 5)

                if taskDistribution.isEmpty {
                    Text("No task data available.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // Display chart as before
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
        let distanceAttempts = SwiftDataManager.shared.fetchDistanceAttempts(forUsername: username)
        let imageToTextAttempts = SwiftDataManager.shared.fetchImageToTextAttempts(forUsername: username)
        let textDistanceAttempts = SwiftDataManager.shared.fetchTextDistanceAttempts(forUsername: username)

        let distanceCount = distanceAttempts.count
        let imageToTextCount = imageToTextAttempts.count
        let textDistanceCount = textDistanceAttempts.count

        taskDistribution = [
            ("Distance", distanceCount),
            ("Image to Text", imageToTextCount),
            ("Text Distance", textDistanceCount)
        ]
    }
}
