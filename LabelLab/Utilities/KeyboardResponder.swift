import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var animationDuration: Double = 0.25
    @Published var animationCurve: UIView.AnimationCurve = .easeInOut

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                guard let self = self else { return }
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = frame.height
                }
                if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    self.animationDuration = duration
                }
                if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                   let animationCurve = UIView.AnimationCurve(rawValue: curve) {
                    self.animationCurve = animationCurve
                }
            }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.keyboardHeight = 0
                self.animationDuration = 0.25
                self.animationCurve = .easeInOut
            }

        keyboardWillShow.store(in: &cancellableSet)
        keyboardWillHide.store(in: &cancellableSet)
    }
}