//
//  MoviesListTableViewController.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/22/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let movieCellHeight: CGFloat = 80.0
private let movieCellIdentifier = "MovieCell"

class MoviesListTableViewController: UITableViewController {
    
    @IBOutlet weak var headerSearchBar: UISearchBar!
    
    let presenter = MovieListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(view: self)
        presenter.loadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.visibleItemCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return movieCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        let movie = presenter.movie(for: indexPath.row)
        
        cell.tag = indexPath.row
        cell.textLabel?.text = movie.title
        cell.imageView?.sd_setImage(with: movie.imageURL, placeholderImage: #imageLiteral(resourceName: "bike"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            updateDetailScreen(with: presenter.movie(for: indexPath.row))
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if headerSearchBar.isFirstResponder { headerSearchBar.deactivate() }
        if let detailVC = segue.destination as? MovieDetailViewController, let cell = sender as? UITableViewCell {
            detailVC.movie = presenter.movie(for: cell.tag)
        }
    }
   
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return UIDevice.current.userInterfaceIdiom != .pad
    }
    
}

extension MoviesListTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.deactivate()
        presenter.removeSearchResultData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.deactivate()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateSearchResult(for: searchText)
    }
}

extension MoviesListTableViewController: MovieListView {
    
    var searchedText: String? {
        return headerSearchBar.text
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoaderIndicator() {
        SVProgressHUD.show()
    }
    
    func hideLoaderIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func showError(with message: String?) {
        AlertController.showErrorAlert(with: message, target: self)
    }
    
    func updateDetailScreen(with movie: MovieListItem) {
        guard let navBar = splitViewController?.viewControllers.last as? UINavigationController else { return }
        if let detailVC = navBar.viewControllers.first as? MovieDetailViewController {
            detailVC.movie = movie
            detailVC.updateUI()
        }
    }
    
}

