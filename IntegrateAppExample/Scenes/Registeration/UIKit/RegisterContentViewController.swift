import RxCocoa
import RxSwift
import UIKit
import SwiftUI

final class RegisterContentViewController: VStackViewController {
    enum UI {
        case uikit
        case swiftui
    }

    // Components with UIKit
    private let userName =
        FormViewController(
            dependency: .init(
                title: "Nickname",
                placeholder: "Nickname",
                validation: FormValidationService.shared.validate(nickName:), textContentType: .givenName
            )
    )

    private let email =
        FormViewController(
            dependency:
            .init(
                title: "Email",
                placeholder: "Email",
                validation: FormValidationService.shared.validate(email:),
                textContentType: .emailAddress
            )
    )

    private let creditCard = FormViewController(
        dependency: .init(
            title: "Credit card number",
            placeholder: "Credit card number",
            validation: FormValidationService.shared.validate(creditCard:),
            textContentType: .creditCardNumber
        )
    )

    private let expiration = FormViewController(
        dependency:
        .init(
            title: "Expiration Date",
            placeholder: "MM/YY",
            validation: FormValidationService.shared.validate(expirationDate:),
            keyboardType: .numbersAndPunctuation))

    private let securityCode = FormViewController(
        dependency:
        .init(
            title: "Security code",
            placeholder: "Digits",
            validation: FormValidationService.shared.validate(securityCode:),
            keyboardType: .numberPad,
            isSecureTextEntry: true
        )
    )

    // Components with SwiftUI
    private let userNameView = UIHostingController(
        rootView: FormView(
            dependency: .init(
                title: "Nickname",
                placeholder: "Nickname",
                validation: FormValidationService.shared.validate(nickName:), textContentType: .givenName
            )
    ))

    private let emailView = UIHostingController(
        rootView: FormView(
            dependency: .init(
                title: "Email",
                placeholder: "Email",
                validation: FormValidationService.shared.validate(email:),
                textContentType: .emailAddress
            )
    ))

    private let creditCardView = UIHostingController(
        rootView: FormView(
            dependency: .init(
                title: "Credit card number",
                placeholder: "Credit card number",
                validation: FormValidationService.shared.validate(creditCard:),
                textContentType: .creditCardNumber
            )
    ))

    private let expirationView = UIHostingController(
        rootView: FormView(
            dependency: .init(
                title: "Expiration Date",
                placeholder: "MM/YY",
                validation: FormValidationService.shared.validate(expirationDate:),
                keyboardType: .numbersAndPunctuation)
    ))

    private let securityCodeView = UIHostingController(
        rootView: FormView(
            dependency: .init(
                title: "Security code",
                placeholder: "Digits",
                validation: FormValidationService.shared.validate(securityCode:),
                keyboardType: .numberPad,
                isSecureTextEntry: true
            )

    ))

    lazy var isValidateForms: Driver<Bool> = {
        switch ui {
        case .uikit:
            return Driver.combineLatest(
                userName.isValid,
                email.isValid,
                creditCard.isValid,
                securityCode.isValid,
                expiration.isValid
            ) {
                $0 && $1 && $2 && $3 && $4
            }
            .distinctUntilChanged()
        case .swiftui:
            return Observable<Bool>
                .just(userNameView.rootView.isValid
                    && emailView.rootView.isValid
                    && creditCardView.rootView.isValid
                    && securityCodeView.rootView.isValid
                    && expirationView.rootView.isValid)
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: false)
        }
    }()

    let ui: UI
    private let disposeBag = DisposeBag()

    init(ui: UI) {
        self.ui = ui

        switch ui {
        case .uikit:
            super.init(
                components: [
                    userName,
                    email,
                    creditCard,
                    HStackViewController(
                        components: [expiration, securityCode]
                    )
                ]
            )
        case .swiftui:
            super.init(
                components: [
                    userNameView,
                    emailView,
                    creditCardView,
                    HStackViewController(
                        components: [expirationView, securityCodeView]
                    )
                ]
            )
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.backBarButtonItem = nil
    }
}
