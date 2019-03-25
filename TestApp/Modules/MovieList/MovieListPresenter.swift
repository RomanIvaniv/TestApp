//
//  MovieListPresenter.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit
import Foundation

protocol MovieListView: NSObjectProtocol {
    
    var searchedText: String? { get }
    
    func reloadData()
    func showLoaderIndicator()
    func hideLoaderIndicator()
    func showError(with message: String?)
    func updateDetailScreen(with movie: MovieItem)
    
}

class MovieListPresenter {
    
    weak private var listView : MovieListView?

    private var searchResult: [MovieItem]?

    private let movieService: MovieService = MovieClient()    
    
    private var movies = [MovieItem]() {
        didSet {
            listView?.reloadData()
        }
    }
    
    //MARK: - Getters
    
    private var showSearchResult: Bool {
        guard let text = listView?.searchedText else {
            return false
        }
        return !text.isEmpty
    }
    
    var visibleItemCount: Int {
        guard let searchData = searchResult, showSearchResult else {
            return movies.count
        }
        return searchData.count
    }
    
    //MARK: - Public
    
    func attachView(view: MovieListView) {
        listView = view
    }
    
    func loadData() {
        listView?.showLoaderIndicator()
        movieService.movieList { (result, errorMessage) in
            self.listView?.hideLoaderIndicator()
            guard let items = result as? [MovieItem] else {
                self.listView?.showError(with: errorMessage)
                return
            }
            self.movies = items
            self.updateDetailControllerIfNeeded()
        }        
    }
    
    func updateSearchResult(for text: String) {
        guard !text.isEmpty else {
            removeSearchResultData()
            return
        }
        searchResult = movies.filter { $0.title != nil && $0.title!.lowercased().contains(text.lowercased()) }
        listView?.reloadData()
    }
    
    func removeSearchResultData() {
        searchResult = nil
        listView?.reloadData()
    }
    
    func movie(for index: Int) -> MovieItem {
        guard let searchData = searchResult, showSearchResult else {
            return movies[index]
        }
        return searchData[index]
    }
    
    //MARK: - Private
    
    private func updateDetailControllerIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad, let firstMovie = movies.first {
            //show first movie on detail screen as default
            listView?.updateDetailScreen(with: firstMovie)
        }
    }
    
}
