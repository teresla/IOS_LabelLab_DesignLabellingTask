import SwiftUI

struct TextVisualView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()
            .background(Capsule().fill())
            .frame(maxWidth: 120, maxHeight: 120)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
}
