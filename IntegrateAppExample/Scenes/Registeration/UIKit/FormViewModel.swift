import RxCocoa
import RxSwift

struct FormViewModel {
    let validatedValue: Driver<ValidationResult>

    init(text: Driver<String>, validation: @escaping (String) -> ValidationResult) {
        validatedValue = text.map { text in
            validation(text)
        }
    }
}
