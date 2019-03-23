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
    
    let movieService: MovieService = MovieClient()
    
    var movies = [MovieListItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var showSearchResult: Bool {
        guard let text = headerSearchBar.text else {
            return false
        }
        return !text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        movieService.movieList { (result, error) in
            SVProgressHUD.dismiss()
            guard let items = result as? [MovieListItem] else {
                //show error
                return
            }
            self.movies = items
        }

        tableView.setContentOffset(CGPoint(x: 0, y: headerSearchBar.frame.height), animated: false)
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return movieCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.imageView?.sd_setImage(with: movie.imageURL, placeholderImage: nil, completed: nil)
        
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
