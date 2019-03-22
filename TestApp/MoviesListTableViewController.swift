//
//  MoviesListTableViewController.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/22/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit

private let movieCellIdentifier = "MovieCell"

class MoviesListTableViewController: UITableViewController {
    
    @IBOutlet weak var headerSearchBar: UISearchBar!
    
    fileprivate var showSearchResult: Bool {
        guard let text = headerSearchBar.text else {
            return false
        }
        return !text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setContentOffset(CGPoint(x: 0, y: headerSearchBar.frame.height), animated: false)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        
        return cell
    }
   
}

extension MoviesListTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.deactivate()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.deactivate()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filter data
    }
}

//create some helper file
extension UISearchBar {
    func deactivate(animated: Bool = true) {
        resignFirstResponder()
        setShowsCancelButton(false, animated: animated)
    }
}
