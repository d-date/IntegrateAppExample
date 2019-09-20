import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                if let windowScene = scene as? UIWindowScene {
            let coordinator = RootCoordinator(window: .init(windowScene: windowScene))
            self.window = coordinator.window
        }
    }
}
