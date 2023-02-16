//
//  SetsViewController.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit
import RealmSwift

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
        
        setsSearchBar.delegate = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets(onReturn: true)
        }
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
            }catch {
                print(error)
            }
        }
    }

    
    private func updateSets(onReturn: Bool = false){
        if(onReturn){
            updateSetsOnReturn()
        }else{
            updateSetsWithTransitition()
        }
    
        
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIBarButtonItem) {
        let addSetViewController = AddSetViewController(nibName: NibNames.AddSetViewControllerNibName, bundle: nil)
        
        addSetViewController.modalPresentationStyle = .overFullScreen
        
        present(addSetViewController, animated: true)
    }
   
}

extension SetsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[indexPath.row]
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let singleSetViewController = self.storyboard?.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
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
