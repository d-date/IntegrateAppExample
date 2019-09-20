import Foundation
import SwiftUI

@available(iOS 13.0, *)
class FormViewSwiftUIModel: ObservableObject {
    let validation: (String) -> ValidationResult
    var value: String = "" {
        willSet {
            if newValue != value {
                validationResult = self.validation(newValue)
            }
        }
    }

    var validationResult: ValidationResult = .empty {
        willSet {
            switch newValue {
            case .failed(let message):
                errorMessage = message
            case .ok:
                isValid = true
                isEmpty = false
            case .empty:
                isValid = false
                isEmpty = true
            default:
                errorMessage = ""
            }
            objectWillChange.send()
        }
    }
    var isEmpty: Bool = true
    var isValid: Bool = false
    var errorMessage: String = ""
    init(value: String = "", validation: @escaping (String) -> ValidationResult) {
        self.value = value
        self.validation = validation
    }
}
