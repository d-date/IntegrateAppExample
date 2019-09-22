import RxCocoa
import RxSwift
import UIKit
import SwiftUI

final class RegisterViewController: UIViewController, KeyboardObservable {
    @IBOutlet var contentView: UIView!
    @IBOutlet var confirmView: UIView!

    private let ui: RegisterContentViewController.UI

    private lazy var contentViewController = RegisterContentViewController(ui: ui)

    // for SwiftUI
//    private lazy var contentViewController = UIHostingController(rootView: RegisterContentView())
    private lazy var confirmViewController = RegisterDecisionViewController()
    private let disposeBag = DisposeBag()

    @IBOutlet var bottomAnchor: NSLayoutConstraint!
    var initialBottomAnchorValue: CGFloat = 0
    var observers: [NSObjectProtocol]? = [NSObjectProtocol]()

    init(ui: RegisterContentViewController.UI) {
        self.ui = ui
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observers?.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"

        addChild(contentViewController)
        addChild(confirmViewController)

        contentView.addSubview(contentViewController.view, constraints: .allEdges())
        confirmView.addSubview(confirmViewController.view, constraints: .allEdges())

        contentViewController.didMove(toParent: self)
        confirmViewController.didMove(toParent: self)

        setupKeyboardNotifications(keyboardWillShow: { [weak self] notification in
            guard let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                    return
            }

            self?.bottomAnchor?.constant = rect.height
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [],
                           animations: { self?.view.layoutIfNeeded() },
                           completion: nil)
            }, keyboardWillHide: { [weak self] notification in
                guard let self = self, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                        return
                }

                self.bottomAnchor?.constant = self.initialBottomAnchorValue
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: [],
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }, keyboardWillChangeFrame: { [weak self] notification in
            guard let self = self,
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                    return
            }

            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [],
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        })

//            contentViewController.isValidateForms
        contentViewController.isValidateForms
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.confirmViewController.set(isValid: $0)
            })
            .disposed(by: disposeBag)

        confirmViewController.registerButton.rx.tap
            .subscribe(onNext: {
                //TODO: show indicator
                //TODO: post user data
            })
            .disposed(by: disposeBag)

        confirmViewController.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
