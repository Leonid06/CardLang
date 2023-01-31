//
//  SceneDelegate.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let authenticationRepository = AuthenticationRepository.shared

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func goToController(with viewController: UIViewController?) {
        Task {
            UIView.animate(withDuration: 0.25){
                self.window?.layer.opacity = 0
            } completion: { _ in
                if let viewController = viewController {
//                    let navigationController = UINavigationController(rootViewController: viewController)
                    viewController.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = viewController
                    
                    UIView.animate(withDuration: 0.25){
                        self.window?.layer.opacity = 1
                    }
                }
            }
        }
    }
    
    func checkAuthentication(){
        Task {
            await authenticationRepository.checkIfUserIsLoggedIn(completion: navigateOnAuthenticationCheck(isAuthenticated:))
        }
    }
    
    private func navigateOnAuthenticationCheck(isAuthenticated: Bool){
        if(isAuthenticated){
            let homeStoryboard = UIStoryboard(name : StoryboardNames.MainStoryboardName, bundle: nil)
            let homeViewController = homeStoryboard.instantiateInitialViewController()
            goToController(with: homeViewController)
        }else {
            let authenticationStoryboard = UIStoryboard(name: StoryboardNames.AuthenticationStoryboardName, bundle: nil)
            let loginViewController = authenticationStoryboard.instantiateInitialViewController()
            goToController(with: loginViewController)
        }
    }
    
    private func setupWindow(with scene: UIScene) {
          guard let windowScene = (scene as? UIWindowScene) else { return }
          let window = UIWindow(windowScene: windowScene)
          self.window = window
          self.window?.makeKeyAndVisible()
      }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

