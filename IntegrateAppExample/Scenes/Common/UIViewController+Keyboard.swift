import UIKit

protocol KeyboardObservable: AnyObject {
    var observers: [NSObjectProtocol]? { get set }
    var initialBottomAnchorValue: CGFloat { get set }
    var bottomAnchor: NSLayoutConstraint! { get set }
}

extension KeyboardObservable where Self: UIViewController {
    var defaultCompletion: (Notification) -> Void { { [weak self]  notification in self?.changeKeyboard(notification) }
    }

    func setupKeyboardNotifications(
        keyboardWillShow: ((Notification) -> Void)? = nil,
        keyboardWillHide: ((Notification) -> Void)? = nil,
        keyboardWillChangeFrame: ((Notification) -> Void)? = nil
        ) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: keyboardWillShow ?? defaultCompletion)
            .store(in: &observers)

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: keyboardWillHide ?? defaultCompletion)
            .store(in: &observers)

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: keyboardWillChangeFrame ?? defaultCompletion)
            .store(in: &observers)

        initialBottomAnchorValue = bottomAnchor.constant
    }

    func changeKeyboard(_ notification: Notification) {
        guard let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }

        bottomAnchor?.constant = rect.height + initialBottomAnchorValue
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [],
                       animations: { [unowned self] in self.view.layoutIfNeeded() },
                       completion: nil)
    }
}
