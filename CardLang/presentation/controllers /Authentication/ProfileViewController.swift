//
//  ProfileViewController.swift
//  CardLang
//
//  Created by Leonid on 31.01.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    
    private let authenticationRepository = AuthenticationRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUserCustomData()
    }

    @IBAction func logOutButtonClicked(_ sender: Any) {
        Task {
            await authenticationRepository.logOut {
                loggedOut in self.onLoggedOut(loggedOut)
            }
        }
        
    }
    
    private func fetchCurrentUserCustomData(){
        Task {
            if let email = authenticationRepository.getCurrentUserEmail(){
                idLabel.text = "email: \(email)"
            }
            
        }
    }
    

    private func onLoggedOut(_ loggedOut: Bool){
        if(loggedOut){
            Task {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
    }
}
