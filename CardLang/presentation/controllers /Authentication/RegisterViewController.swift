//
//  RegisterViewController.swift
//  CardLang
//
//  Created by Leonid on 29.01.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let authenticationRepository = AuthenticationRepository.shared

    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        if let password = passwordTextField.text, let email = emailTextField.text {
            Task {
                await authenticationRepository.registerUser(email: email, password: password){
                    registered in self.onRegistrationRequestCompleted(registered)
                }
            }
           
        }
    }
    
    private func onRegistrationRequestCompleted(_ registered: Bool){
        if(registered){
            Task {
                navigationController?.popToRootViewController(animated: true)
            }
        }else {
            Task {
                self.displayAlert(title: "Registration failed", message: "Error happened", dismissButtonTitle: "OK")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
    }
}
