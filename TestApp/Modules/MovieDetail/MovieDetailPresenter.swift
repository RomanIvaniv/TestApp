//
//  MovieDetailPresenter.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation
import YoutubeDirectLinkExtractor

protocol MovieDetailView: NSObjectProtocol {

    func updateNavBarItem()
    func playTrailer(url: URL)
    func hideLoaderIndicator()
    func setMovie(_ movie: MovieItem)
    func showError(with message: String?)
    func showLoaderIndicator(with message: String?)
    func showAlert(title: String?, message: String?)
    func showActivityIndicator(for type: ActivityIndicatorType)
    func hideActivityIndicator(for type: ActivityIndicatorType)

}

class MovieDetailPresenter {
    
    weak private var detailView : MovieDetailView?

    let movieService: MovieService = MovieClient()
    
    //MARK: - Public
    
    func attachView(view: MovieDetailView) {
        detailView = view
    }
    
    func hasLocalTrailer(for movie: MovieItem?) -> Bool {
        guard let movie = movie, let movieID = movie.uniqueID else { return false }
        return OfflineStorage.hasTrailer(for: movieID)
    }
    
    func loadDetail(for movie: MovieItem?) {
        guard let movie = movie else { return }
        detailView?.showActivityIndicator(for: .genres)
        movieService.movieDatail(for: movie) { (item, error) in
            self.detailView?.hideActivityIndicator(for: .genres)
            guard let updatedMovie = item as? MovieItem else {
                self.detailView?.showError(with: error)
                return
            }
            self.detailView?.setMovie(updatedMovie)
        }
    }
    
    func watchTrailer(for movie: MovieItem) {
        guard Reachability.isConnectedToInternet() else {
            guard let movieID = movie.uniqueID, let url = OfflineStorage.loadTrailerURL(for: movieID) else {
                self.detailView?.showError(with: "Can't obtain trailer url")
                return
            }
            self.detailView?.playTrailer(url: url)
            return
        }        
        detailView?.showActivityIndicator(for: .trailers)
        movieService.movieTrailers(for: movie) { (items, error) in
            guard let trailers = items as? [String], let firstTrailer = trailers.first else {
                self.detailView?.hideActivityIndicator(for: .trailers)
                self.detailView?.showError(with: error)
                return
            }
            let youtubeExtractor = YoutubeDirectLinkExtractor() //need to play video from youtube
            youtubeExtractor.extractInfo(for: .urlString(firstTrailer), success: { info in
                self.detailView?.hideActivityIndicator(for: .trailers)
                guard let link = info.highestQualityPlayableLink, let url = URL(string: link) else {
                    self.detailView?.hideActivityIndicator(for: .trailers)
                    self.detailView?.showError(with: "Can't obtain trailer url")
                    return
                }
                self.detailView?.playTrailer(url: url)
            }) { error in
                self.detailView?.showError(with: error.localizedDescription)
            }
        }
    }
    
    func downloadTrailer(for movie: MovieItem?) {
        guard let movie = movie, let identifier = movie.uniqueID else { return }
        detailView?.showLoaderIndicator(with: "Saving...")
        movieService.movieTrailers(for: movie) { (items, error) in
            guard let trailers = items as? [String], let firstTrailer = trailers.first else {
                self.detailView?.hideLoaderIndicator()
                self.detailView?.showError(with: error)
                return
            }
            let youtubeExtractor = YoutubeDirectLinkExtractor()
            youtubeExtractor.extractInfo(for: .urlString(firstTrailer), success: { info in
                guard let link = info.highestQualityPlayableLink, let url = URL(string: link) else {
                    self.detailView?.hideLoaderIndicator()
                    self.detailView?.showError(with: "Can't obtain trailer url")
                    return
                }
                OfflineStorage.saveTrailer(for: identifier, with: url, complation: { success in
                    self.detailView?.hideLoaderIndicator()
                    guard success else {
                        self.detailView?.showError(with: "Can't save trailer")
                        return
                    }
                    self.detailView?.updateNavBarItem()
                    self.detailView?.showAlert(title: "Success", message: "Now you can watch this trailer in offline")
                })
            }) { error in
                self.detailView?.showError(with: error.localizedDescription)
            }
        }
    }
   
}
