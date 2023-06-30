//
//  TableViewController.swift
//  searchbar
//
//  Created by Ovidiu P. Muntean on 30.06.2023.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
            
    var items: [Items] = []
    var filteredItems: [Items] = []
    let searchController = UISearchController()
    
    @IBOutlet var itemsTableView: UITableView!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [Items(name: "My item", category: Items.Category.mine),
                 Items(name: "Team item", category: Items.Category.mine),
                 Items(name: "Other item", category: Items.Category.other)]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initSearchController()
    }
            
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        
        searchController.searchBar.autocapitalizationType = .none
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // Make the search bar always visible.
        searchController.searchBar.scopeButtonTitles = ["All", "Mine", "Team", "Others"]
        searchController.searchBar.delegate = self
    }
            
            // MARK: - Table view data source
            
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
            
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
            
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let thisItem: Items!
        
        if (searchController.isActive) {
            thisItem = filteredItems[indexPath.row]
        } else {
            thisItem = items[indexPath.row]
        }
        
        cell.textLabel?.text = thisItem.name
        
        return cell
    }
            
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filteredItems = items.filter { item in
            let scopeMatch = (scopeButton == "All" || item.category == .all)
            if (searchController.searchBar.text != "") {
                let searchTextMatch = item.name.lowercased().contains(searchText.lowercased())
                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        
        itemsTableView.reloadData()
    }
}
