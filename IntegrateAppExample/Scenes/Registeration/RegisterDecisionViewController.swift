import UIKit

class RegisterDecisionViewController: UIViewController {
    @IBOutlet var registerButton: UIButton! {
        didSet {
            registerButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet var skipButton: UIButton! {
        didSet {
            skipButton.layer.cornerRadius = 4
        }
    }

    func set(isValid: Bool) {
        registerButton.isEnabled = isValid
    }
}
