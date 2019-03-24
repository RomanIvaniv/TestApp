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

    func playTrailer(url: URL)
    func setMovie(_ movie: MovieItem)
    func showError(with message: String?)
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
    
    func loadTrailers(for movie: MovieItem?) {
        guard let movie = movie else { return }
        detailView?.showActivityIndicator(for: .trailers)
        movieService.movieTrailers(for: movie) { (items, error) in
            self.detailView?.hideActivityIndicator(for: .trailers)
            guard let trailers = items as? [String], let firstTrailer = trailers.first else {
                self.detailView?.showError(with: "No trailers for play :(")
                return
            }
            let youtubeExtractor = YoutubeDirectLinkExtractor() //need to play video from youtube
            youtubeExtractor.extractInfo(for: .urlString(firstTrailer), success: { info in
                guard let link = info.highestQualityPlayableLink, let url = URL(string: link) else {
                    self.detailView?.showError(with: "Can't obtain trailer url")
                    return
                }
                self.detailView?.playTrailer(url: url)
            }) { error in
                self.detailView?.showError(with: error.localizedDescription)
            }
        }
    }
    
}
