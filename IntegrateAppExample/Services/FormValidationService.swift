import RxSwift

struct FormValidationService: FormValidation {
    static let shared = FormValidationService()

    func validate(email: String) -> ValidationResult {
        let pattern = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
        if email.isEmpty {
            return .empty
        }
        guard email.range(of: pattern, options: .regularExpression) != nil else {
            return .failed(message: "Invalid email format")
        }
        return .ok(message: "")
    }

    func validate(nickName: String) -> ValidationResult {
        if nickName.isEmpty {
            return .empty
        }
        return .ok(message: "")
    }

    func validate(creditCard: String) -> ValidationResult {
        if creditCard.isEmpty {
            return .empty
        }

        guard 15...16 ~= creditCard.count else {
            return .failed(message: "Invalid credit card format")
        }
        return .ok(message: "")
    }

    func validate(phoneNumber: String) -> ValidationResult {
        let pattern = #"\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$"#

        if phoneNumber.isEmpty {
            return .empty
        }

        guard phoneNumber.hasPrefix("+") else {
            return .failed(message: "Invalid phone number format")
        }

        guard phoneNumber.range(of: pattern, options: .regularExpression) != nil else {
            return .failed(message: "Invalid phone number format")
        }
        return .ok(message: "")
    }

    func validate(securityCode: String) -> ValidationResult {
        if securityCode.isEmpty {
            return .empty
        }

        guard 3...4 ~= securityCode.count else {
            return .failed(message: "input 3 or 4 digits")
        }
        return .ok(message: "")
    }

    func validate(expirationDate: String) -> ValidationResult {
        if expirationDate.isEmpty {
            return .empty
        }
        return .ok(message: "")
    }
}
