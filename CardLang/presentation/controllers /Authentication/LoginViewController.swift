//
//  LoginViewController.swift
//  CardLang
//
//  Created by Leonid on 29.01.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let authenticationRepository = AuthenticationRepository.shared

    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let registerViewController = RegisterViewController(nibName: NibNames.RegisterViewControllerNibName, bundle: nil)
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Task {
                await self.authenticationRepository.logInUser(email: email, password: password){
                    loggedIn in self.navigateOnLogin(loggedIn: loggedIn)
                }
            }
        }
    }
    
    private func  navigateOnLogin(loggedIn: Bool){
        if(loggedIn){
            Task {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    }
}
