//
//  SetsViewController.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit

class SetsViewController: UITableViewController {
    
    private var sets = [WordSet]()
    
    private let setRepository = SetRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: NibNames.SetsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Identifies.SetsTableViewCellIdentifier)
        
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSets()
    }

    // MARK: - Table view data source
    
    private func updateSets(){
        
        DispatchQueue.main.async {
            Task {
                do {
                    self.sets = try await self.setRepository.getAllSets()
                    self.tableView.reloadData()
                }catch {
                    print(error)
                }
                
            }
        }
        
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let set = sets[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let singleSetViewController = self.storyboard?.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
        singleSetViewController.set = set
        navigationController?.pushViewController(singleSetViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let set = sets[indexPath.row]
            setRepository.deleteWordSet(set: set)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifies.SetsTableViewCellIdentifier, for: indexPath) as! SetsTableViewCell
        
        let set = sets[indexPath.row]

        cell.nameLabel.text = set.name
        cell.wordCountLabel.text = String(set.translations.count)

        return cell
    }
    
    private func showAlert() {
       let alert = UIAlertController(title: "Add new set", message: nil, preferredStyle: .alert)
       
       alert.addTextField {
           textField in
           textField.placeholder = "Enter the name"
       }
       
       
       let addAction = UIAlertAction(title: "Add", style: .default){
           action in
           if let textFields = alert.textFields {
               if let name = textFields[0].text {
                   self.setRepository.addWordSet(name: name)
               }
           }
       }
       let deleteAction =  UIAlertAction(title: "Cancel", style: .cancel){
           action in
           alert.dismiss(animated: true)
       }
       alert.addAction(addAction)
       alert.addAction(deleteAction)
       
       present(alert, animated: true)
   }
}
