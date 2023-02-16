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
    private func onAccountDeleted(deleted: Bool){
        if(deleted){
            callSceneDelegate()
        }else {
            print("failed to delete account")
        }
    }
    
    private func onDeleteAccountOptionChosen(){
        authenticationRepository.deleteCurrentUserAccount(completion: onAccountDeleted)
    }
    @IBAction func deleteAccountButtonClicked(_ sender: UIButton) {
        self.displayDialog(title: "Account deletion confirmation", message: "Are you sure you want to delete this account?", firstOptionTitle: "Confirm", secondOptionTitle: "Cancel", firstCompletion: onDeleteAccountOptionChosen, secondCompletion: {})
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
    
    private func callSceneDelegate(){
        Task {
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    

    private func onLoggedOut(_ loggedOut: Bool){
        if(loggedOut){
            Task {
                callSceneDelegate()
            }
        }
    }
}
