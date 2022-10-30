//
//  SearchViewController.swift
//  CardLang
//
//  Created by Leonid on 23.09.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    private let setRepository = SetRepository.shared
    
    private let cardRepository = CardRepository.shared
    
    private var set : WordSet?
    
    private var translations  = [Translation]()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let primaryColor = UIColor(named: Colors.buttonColor)
        
//        searchBar.setIconColor(primaryColor ?? UIColor())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: NibNames.SearchTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Identifies.SearchTableViewCellIdentifier)
        
        title = "Search"
        
        searchBar.delegate = self
    }
    
    private func updateData(){
        tableView.reloadData()
    }
    
    private func onDefinitionsFetched(translations : [Translation]){
        self.translations = translations
        print(translations.count)
        updateData()
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
            setRepository.addTranslationToSet(set: set, translation: translation, completion: {})
        }
//        navigationController?.popViewController(animated: true)
        
        if let viewController = navigationController?.viewControllers.first(where: {$0 is SingleSetViewController}) {
            navigationController?.popToViewController(viewController, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
