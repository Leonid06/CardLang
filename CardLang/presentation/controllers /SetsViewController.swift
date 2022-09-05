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
        updateSets()
        
    }

    // MARK: - Table view data source
    
    private func updateSets(){
        sets = setRepository.getAllSets()
        tableView.reloadData()
    }
    
    @IBAction func addSetButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sets.count
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let set = sets[indexPath.row]
        let singleSetViewController = SingleSetCollectionViewController()
        
        singleSetViewController.set = set
        navigationController?.pushViewController(singleSetViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
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
               
               self.updateSets()
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
