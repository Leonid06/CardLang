//
//  SearchViewController.swift
//  CardLang
//
//  Created by Leonid on 23.09.2022.
//

import UIKit
import EmptyStateKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let setRepository = SetRepository.shared
    private let cardRepository = CardRepository.shared
    
    private var set : WordSet?
    
    private var translations  = [Translation]()
    
    var delegate : PopUpControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyState.format = getEmptyStateFormat()
        
        tableView.register(UINib(nibName: NibNames.SearchTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Identifies.SearchTableViewCellIdentifier)
        
        title = "Search"
        
        searchBar.delegate = self
    }
    
    
    
    private func updateData(dataIsEmpty: Bool = false){
        if(dataIsEmpty){
            tableView.emptyState.show(EmptyState.noResults)
        }else {
            tableView.emptyState.hide()
        }
        tableView.reloadData()
    }
    
    private func onDefinitionsFetched(translations : [Translation]){
        self.translations = translations
        
        if(self.translations.count == 0){
            updateData(dataIsEmpty: true)
        }else {
            updateData()
        }
    }
    
    func configure(_ set : WordSet){
        self.set = set
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
        tableView.deselectRow(at: indexPath, animated: true)
        if let set = self.set {
            setRepository.addTranslationToSet(set: set, translation: translation){
                self.delegate?.onDismissed()
            }
        }
        dismiss(animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let word = searchBar.text {
            cardRepository.fetchMultipleTranslationsForWord(word, completion: onDefinitionsFetched)
        }
        searchBar.endEditing(false)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let isEmpty = searchBar.text?.isEmpty {
            if(isEmpty){
                translations.removeAll()
                updateData()
            }
        }
    }
}
