import RxCocoa
import RxSwift
import UIKit

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message

        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
}

extension ValidationResult {
    var isHidden: Bool {
        switch self {
        case .ok, .empty:
            return true

        default:
            return false
        }
    }
}
extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.isHidden = result.isHidden
            label.text = result.description
        }
    }
}
