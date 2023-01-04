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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let setRepository = SetRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSets()
    }

    
    private func updateSets(){
        
        Task {
            do {
                self.sets = try await self.setRepository.getAllSets()
                self.collectionView.reloadData()
            }catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIBarButtonItem) {
//        showAlert()
        let addSetViewController = AddSetViewController(nibName: NibNames.AddSetViewControllerNibName, bundle: nil)
        
        addSetViewController.modalPresentationStyle = .overFullScreen
        
        present(addSetViewController, animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier, for: indexPath) as! SingleFolderCollectionViewCell
        
        
        if let sets = sets {
            let set = sets[sets.count - 1 - indexPath.row]
            cell.configure(set)
        }

        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[sets.count - 1 - indexPath.row]
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let singleSetViewController = self.storyboard?.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
            singleSetViewController.set = set
            navigationController?.pushViewController(singleSetViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[sets.count - 1 - indexPath.row]
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let singleSetViewController = self.storyboard?.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
            singleSetViewController.set = set
            navigationController?.pushViewController(singleSetViewController, animated: true)
        }
       
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 77
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if(editingStyle == .delete){
//
//            if let sets = sets {
//                let set = sets[sets.count - 1 - indexPath.row]
//                setRepository.deleteWordSet(set: set)
//                print("word set was deleted")
//            }
//        }
//    }
}

extension SetsViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
