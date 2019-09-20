import UIKit

class RootCoordinator {
    weak var window: UIWindow?

    init(window: UIWindow) {
        let uikitViewController = RegisterViewController(ui: .uikit)
        let uikitNavigationController = UINavigationController(rootViewController: uikitViewController)
        uikitNavigationController.tabBarItem.title = "UIKit"

        let swiftUIViewController = RegisterViewController(ui: .swiftui)
        let swiftUINavigationController = UINavigationController(rootViewController: swiftUIViewController)
        swiftUINavigationController.tabBarItem.title = "SwiftUI"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [uikitNavigationController, swiftUINavigationController]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
