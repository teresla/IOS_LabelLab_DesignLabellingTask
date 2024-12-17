import SwiftUI

protocol LabellingTask: View, Identifiable {
    var id: UUID { get } // Unique identifier for the task
    var title: String { get } // Title of the task
    var description: String { get } // Description of the task
    var titelImage: Image { get } // Icon for the task
    var typeErasedBody: AnyView { get } // Erased body for dynamic views
}

extension LabellingTask {
    var typeErasedBody: AnyView {
        AnyView(self)
    }
}
