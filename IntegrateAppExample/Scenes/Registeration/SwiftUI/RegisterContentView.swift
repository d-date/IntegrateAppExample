import SwiftUI
import RxSwift
import RxCocoa

@available(iOS 13.0, *, *)
struct RegisterContentView: View {
    private let userName =
        FormViewControllerNoXib(
            //        FormViewController(
            dependency: .init(
                title: "Nickname",
                placeholder: "Nickname",
                validation: FormValidationService.shared.validate(nickName:), textContentType: .givenName
            )
    )

    private let email =
        FormViewControllerNoXib(
            //        FormViewController(
            dependency:
            .init(
                title: "Email",
                placeholder: "Email",
                validation: FormValidationService.shared.validate(email:),
                textContentType: .emailAddress
            )
    )

    private let creditCard =
        FormViewControllerNoXib(
            //        FormViewController(
            dependency: .init(
                title: "Credit card number",
                placeholder: "Credit card number",
                validation: FormValidationService.shared.validate(creditCard:),
                textContentType: .creditCardNumber
            )
    )

    private let expiration =
        FormViewControllerNoXib(
            //        FormViewController(
            dependency:
            .init(
                title: "Expiration Date",
                placeholder: "MM/YY",
                validation: FormValidationService.shared.validate(expirationDate:),
                keyboardType: .numbersAndPunctuation))

    private let securityCode =
        FormViewControllerNoXib(
            //        FormViewController(
            dependency:
            .init(
                title: "Security code",
                placeholder: "Digits",
                validation: FormValidationService.shared.validate(securityCode:),
                keyboardType: .numberPad,
                isSecureTextEntry: true
            )
    )

    lazy var isValidateForms: Driver<Bool> = {
        Driver.combineLatest(
            userName.isValid,
            email.isValid,
            creditCard.isValid,
            securityCode.isValid,
            expiration.isValid
        ) {
            $0 && $1 && $2 && $3 && $4
        }
        .distinctUntilChanged()
    }()

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        self.userName
                        self.email
                        self.creditCard
                        HStack {
                            self.expiration
                            self.securityCode
                            Spacer()
                        }
                    }.frame(height: geometry.size.height)
                    Spacer()
                }
            }
        }
    }
}

@available(iOS 13.0, *)
struct RegisterContentView_Previews: PreviewProvider {
    static var previews: some View {
        let content = RegisterContentView()
        return
            Group {
                NavigationView {
                    content.environment(\.colorScheme, .light)
                }
                NavigationView {
                    content.environment(\.colorScheme, .dark)
                }
        }
    }
}
