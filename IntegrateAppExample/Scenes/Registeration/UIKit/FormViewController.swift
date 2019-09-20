import RxCocoa
import RxSwift
import UIKit
import SwiftUI

final class FormViewController: UIViewController {
    struct Dependency {
        let title: String
        let placeholder: String
        let validation: (String) -> ValidationResult
        let textContentType: UITextContentType?
        let keyboardType: UIKeyboardType?
        let isSecureTextEntry: Bool

        init(title: String, placeholder: String, validation: @escaping (String) -> ValidationResult, textContentType: UITextContentType? = nil, keyboardType: UIKeyboardType? = nil, isSecureTextEntry: Bool = false) {
            self.title = title
            self.placeholder = placeholder
            self.validation = validation
            self.textContentType = textContentType
            self.keyboardType = keyboardType
            self.isSecureTextEntry = isSecureTextEntry
        }
    }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet private var errorLabel: UILabel!

    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    private lazy var viewModel: FormViewModel = .init(text: self.textField.rx.text.orEmpty.asDriver(), validation: self.dependency.validation)

    var isValid: Driver<Bool> {
        return viewModel.validatedValue.map { $0.isValid }
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        titleLabel.text = dependency.title
        textField.placeholder = dependency.placeholder
        textField.textContentType = dependency.textContentType
        textField.isSecureTextEntry = dependency.isSecureTextEntry

        if let keyboardType = dependency.keyboardType {
            textField.keyboardType = keyboardType
        }

        viewModel.validatedValue
            .drive(errorLabel.rx.validationResult)
            .disposed(by: disposeBag)
    }
}

@available(iOS 13.0, *)
extension FormViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = FormViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<FormViewController>) -> FormViewController {
        let formViewController = FormViewController(dependency: self.dependency)
        return formViewController
    }

    func updateUIViewController(_ uiViewController: FormViewController, context: UIViewControllerRepresentableContext<FormViewController>) {

    }

    func makeCoordinator() {

    }
}
