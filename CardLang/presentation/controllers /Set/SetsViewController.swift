//
//  SetsViewController.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit
import RealmSwift
import EmptyStateKit

class SetsViewController: UIViewController {
    
    private var sets : Results<WordSet>?
    

    @IBOutlet weak var setsSearchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let setRepository = SetRepository.shared
    private let searchRepository = SearchRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyState.format = getEmptyStateFormat()
        collectionView.emptyState.delegate = self
        
        setsSearchBar.delegate = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.SingleFolderCollectionViewCellIdentifier)
        
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets(onReturn: true)
        }
    }
    
    private func setsAreEmpty() -> Bool {
        return sets?.isEmpty ?? true
    }
    
    private func updateEmptyState(){
        if(setsSearchBar.text?.isEmpty ?? true){
            if setsAreEmpty() {
                collectionView.emptyState.show(EmptyState.noSets)
                return 
            }
        }else {
            if setsAreEmpty() {
                collectionView.emptyState.show(EmptyState.noSetsFound)
                return
            }
        }
        collectionView.emptyState.hide()
    }
    
    private func updateSetsWithTransitition(){
        Task {
            do {
                let oldData = self.sets
                try await makeQueryOnSets()
                
                if let sets = self.sets {
                    if let oldData = oldData {
                        self.collectionView.reloadChanges(from: oldData , to: sets)
                    }else {
                        self.collectionView.reloadData()
                    }
                    updateEmptyState()
                }
                
            }catch {
                print(error)
            }
        }
    }
    
    private func makeQueryOnSets() async throws {
        let query = setsSearchBar.text
        
        self.sets = try await self.searchRepository.getAllSetsByQuery(query: query ?? "")
    }
    
    private func updateSetsOnReturn(){
        Task {
            do {
                try await makeQueryOnSets()
                self.collectionView.reloadData()
                updateEmptyState()
            }catch {
                print(error)
            }
        }
    }

    
    private func updateSets(onSearch: Bool = false, onReturn: Bool = false){
        if(onReturn){
            updateSetsOnReturn()
        }else{
            updateSetsWithTransitition()
        }
    }
    
    private func addNewWordSet(){
        let addSetViewController = AddSetViewController(nibName: NibNames.AddSetViewControllerNibName, bundle: nil)
        
        addSetViewController.modalPresentationStyle = .overFullScreen
        
        present(addSetViewController, animated: true)
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIBarButtonItem) {
        addNewWordSet()
    }
   
}

extension SetsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sets = sets {
            return sets.count
        }
           
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.SingleFolderCollectionViewCellIdentifier, for: indexPath) as! SingleFolderCollectionViewCell
        
        
        if let sets = sets {
            let set = sets[indexPath.row]
            cell.configure(set)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[indexPath.row]
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let singleSetViewController = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.SingleSetViewControllerIdentifier) as! SingleSetViewController
            singleSetViewController.set = set
            navigationController?.pushViewController(singleSetViewController, animated: true)
        }
    }
}

extension SetsViewController : UICollectionViewDelegateFlowLayout  {
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

extension SetsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSets()
    }
}

extension SetsViewController : EmptyStateDelegate {
    func emptyState(emptyState: EmptyStateKit.EmptyState, didPressButton button: UIButton) {
        addNewWordSet()
    }
}
