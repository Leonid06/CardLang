//
//  SingleFolderViewController.swift
//  CardLang
//
//  Created by Leonid on 17.12.2022.
//

import UIKit
import RealmSwift

class SingleFolderViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let folderRepository = FolderRepository.shared
    private let seacrhRepository = SearchRepository.shared
    private let setRepository = SetRepository.shared
    
    private var folder : Folder?
    
    private var sets :  Results<WordSet>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        folderRepository.subscribeOnUpdatesOnFolders {
            if let folder = self.folder {
                if(!folder.isInvalidated){
                    self.updateSets(onReturn: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
        let addBarButtonItem  = createBarButtonItem(icon: "folder.badge.plus", selector: nil
            ,menu: getAddOptionsMenu())

        
        let editBarButtonItem = createBarButtonItem(icon: "ellipsis.circle", selector: #selector(onEditBarButtonClicked))
        
        navigationItem.rightBarButtonItems = [editBarButtonItem, addBarButtonItem]
        
        searchBar.delegate = self
        
        title = folder?.name
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSets()
    }
    
    
    func configure(_ folder: Folder){
        self.folder = folder 
    }
    
    private func makeQueryOnSets() async throws {
        let query = searchBar.text
        self.sets = try await seacrhRepository.getAllSetsByQuery(query: query ?? "", folder: self.folder)
    }
    
    
    private func updateSetsWithTransition(){
        Task {
            let oldData = self.sets
            
            try await makeQueryOnSets()

            
            if let sets = self.sets {
                if let oldData = oldData {
                    self.collectionView.reloadChanges(from: oldData , to: sets)
                }else {
                    self.collectionView.reloadData()
                }
            }
            
        }
        
        title = folder?.name
    }
    
    private func updateSetsOnReturn(){
        Task {
            do {
                try await makeQueryOnSets()
                self.collectionView.reloadData()
            }catch {
                print(error)
            }
        }
    }
    
    private func updateSets(onReturn: Bool = false){
        if(onReturn){
            updateSetsOnReturn()
        }else{
            updateSetsWithTransition()
        }
    
        
    }
    
    
    @objc func onEditBarButtonClicked(_ sender: Any){
        
        if let folder = folder {
            let editFolderViewController = EditFolderViewController(nibName: NibNames.EditFolderViewControllerNibName, bundle: nil)
            
            editFolderViewController.modalPresentationStyle = .overFullScreen
            
            editFolderViewController.configure(folder)
            
            present(editFolderViewController, animated: true)
        }
    }
}

extension SingleFolderViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sets = sets {
            if(sets.count == 0){
                collectionView.emptyState.show(EmptyState.noSets)
            }else {
                collectionView.emptyState.hide()
            }
            return sets.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier, for: indexPath) as! SingleFolderCollectionViewCell
    
        if let sets = sets {
            let set = sets[indexPath.row]
                cell.configure(set)
            }
    
        return cell
    }
}

extension SingleFolderViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[indexPath.row]
            
            let mainStoryBoard = UIStoryboard(name: NibNames.MainStoryboardName, bundle: nil)
            
            let singleSetViewController = mainStoryBoard.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
            
            singleSetViewController.set = set
            
            navigationController?.pushViewController(singleSetViewController, animated: true)
        }
    }
}

extension SingleFolderViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SingleFolderViewController {
    func getAddOptionsMenu () -> UIMenu {
        let menu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Add new set", image: UIImage(systemName: "note.text.badge.plus")){ action in
                self.navigateToAddSetViewController()
            },
            UIAction(title: "Add existing set", image: UIImage(systemName: "arrow.right.doc.on.clipboard")){ action in
                self.navigateToAddSetToFolderViewController()
            }
        ])
        
        return menu
    }
    
    private func  navigateToAddSetViewController(){
        if let folder = folder {
            let addSetViewController = AddSetViewController(nibName: NibNames.AddSetViewControllerNibName, bundle: nil)
            
            addSetViewController.configure(folder)
            addSetViewController.modalPresentationStyle = .overFullScreen
            
            present(addSetViewController, animated: true)
        }
       
    }

    private func navigateToAddSetToFolderViewController(){
        if let folder = folder {
            let addSetToFolderViewController = AddSetToFolderViewController(nibName: NibNames.AddSetToFolderViewCOntrollerNibName, bundle: nil)
            
            addSetToFolderViewController.configure(folder)
            addSetToFolderViewController.modalPresentationStyle = .overFullScreen
            
            present(addSetToFolderViewController, animated: true)
        }
        
    }
}

extension SingleFolderViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSets()
    }
}


