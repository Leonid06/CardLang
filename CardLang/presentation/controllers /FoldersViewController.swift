//
//  FoldersViewController.swift
//  CardLang
//
//  Created by Leonid on 04.12.2022.
//

import UIKit
import RealmSwift

class FoldersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let folderRepository = FolderRepository.shared
    
    private var folders  : Results<Folder>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: NibNames.FolderTableViewCellNibName , bundle: nil) , forCellReuseIdentifier: Identifies.FolderTableViewCellIdentifier)
        
        
        folderRepository.subscribeOnUpdatesOnFolders {
            self.updateFolders()
        }
    }
    @IBAction func addFolderButtonClicked(_ sender: Any) {
        let addFolderViewController = AddFolderViewController(nibName: NibNames.AddFolderViewControllerNibName, bundle: nil)
        
        addFolderViewController.modalPresentationStyle = .overCurrentContext
        present(addFolderViewController, animated: true)
    }
    
    private func updateFolders() {
        Task {
            do {
                self.folders = try await self.folderRepository.getAllFolders()
                self.tableView.reloadData()
            }catch {
                print(error)
            }
        }
    }
}


extension FoldersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension FoldersViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let folders = folders {
            return folders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifies.FolderTableViewCellIdentifier, for: indexPath) as! FolderTableViewCell
        
        return cell
    }
}
