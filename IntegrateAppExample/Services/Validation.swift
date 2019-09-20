import RxSwift

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

protocol FormValidation {
    func validate(nickName: String) -> ValidationResult
    func validate(email: String) -> ValidationResult
    func validate(phoneNumber: String) -> ValidationResult
    func validate(creditCard: String) -> ValidationResult
    func validate(expirationDate: String) -> ValidationResult
    func validate(securityCode: String) -> ValidationResult
}
