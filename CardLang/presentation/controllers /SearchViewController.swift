//
//  SearchViewController.swift
//  CardLang
//
//  Created by Leonid on 23.09.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let setRepository = SetRepository.shared
    
    private var set : WordSet?
    
    private var translations  = [Translation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: NibNames.SearchTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Identifies.SearchTableViewCellIdentifier)
        
        title = "Search"
        
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController

        // Do any additional setup after loading the view.
    }
    
    func configure(_ set : WordSet){
        self.set = set
    }
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension SearchViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifies.SearchTableViewCellIdentifier) as! SearchTableViewCell
        
        let translation = translations[indexPath.row]
        
        cell.configure(translation)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let translation = translations[indexPath.row]
        if let set = self.set {
            setRepository.addTranslationToSet(set: set, translation: translation)
        }
        navigationController?.dismiss(animated: true)
    }
    
    
}
