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
        let category = Items.Category(from: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        
        filterContentForSearchText(searchBar.text!, category: category)
    }
            
    var items = [Items]()
    var filteredItems = [Items]()
    let searchController = UISearchController()
    
    @IBOutlet var itemsTableView: UITableView!
            
    override func viewDidLoad() {
        super.viewDidLoad()
           
        items.append(Items(name: "My item", category: Items.Category.mine))
        items.append(Items(name: "Team item", category: Items.Category.mine))
        items.append(Items(name: "Other item", category: Items.Category.mine))
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
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
        return 1
    }
            
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String, category: Items.Category? = nil) {
      filteredItems = items.filter { (item: Items) -> Bool in
        let categoryMatch = category == .all || item.category == category
        
        if isSearchBarEmpty {
            return categoryMatch
        } else {
            return categoryMatch && item.name.lowercased().contains(searchText.lowercased())
        }
      }
      
      tableView.reloadData()
    }
}
