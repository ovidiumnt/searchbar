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
        let category = Items.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        
        filterContentForSearchText(searchBar.text!, category: category)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Items.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        
        filterContentForSearchText(searchBar.text!, category: category)
    }
            
    var items = [Items]()
    var filteredItems = [Items]()
    let searchController = UISearchController()
    
    @IBOutlet var itemsTableView: UITableView!
            
    override func viewDidLoad() {
        super.viewDidLoad()
           
        items.append(Items(name: "MY ITEM 1", category: Items.Category.mine))
        items.append(Items(name: "MY ITEM 2", category: Items.Category.mine))
        items.append(Items(name: "TEAM ITEM 1", category: Items.Category.team))
        items.append(Items(name: "TEAM ITEM 2", category: Items.Category.team))
        items.append(Items(name: "TEAM ITEM 3", category: Items.Category.team))
        items.append(Items(name: "OTHER ITEM 1", category: Items.Category.others))
        items.append(Items(name: "OTHER ITEM 2", category: Items.Category.others))
        items.append(Items(name: "OTHER ITEM 3", category: Items.Category.others))
        items.append(Items(name: "OTHER ITEM 4", category: Items.Category.others))
        
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
        searchController.searchBar.delegate = self
        initSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
            
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
            
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredItems.count
        }

        return items.count
    }
            
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentItem: Items
        
        if (isFiltering) {
            currentItem = filteredItems[indexPath.row]
        } else {
            currentItem = items[indexPath.row]
        }
        
        cell.textLabel?.text = currentItem.name
        cell.detailTextLabel?.text = "Acest item face parte din categoria \(currentItem.category.rawValue.uppercased())"
        
        return cell
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.searchBar.scopeButtonTitles = ["ALL", "MINE", "TEAM", "OTHERS"]
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // Make the search bar always visible.
        
        definesPresentationContext = true
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
