//
//  MovieDetailViewController.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/22/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    var movie: MovieListItem!
    
    let movieService: MovieService = MovieClient()

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        movieService.movieDatail(for: movie) { (item, error) in
            guard let updatedMovie = item as? MovieListItem else { return }
            self.movie = updatedMovie
            self.genreLabel.text = updatedMovie.genres?.joined(separator: ", ")
        }
    }
    
    
    private func setupUI() {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseData
        overviewLabel.text = movie.overview
        iconImageView.sd_setImage(with: movie.imageURL, placeholderImage: #imageLiteral(resourceName: "movie_placeholder"))
    }
    
    
    
    @IBAction func watchTrailerAction(_ sender: UIButton) {
        //play first from list
        
        
        movieService.movieTrailers(for: movie) { (items, error) in
            guard let trailers = items as? [String], let firstTrailer = trailers.first else {
                return
            }
            
            DispatchQueue.main.async {
                let url = URL(string: firstTrailer)!

                self.player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = self.player

                vc.player?.play()

                self.present(vc, animated: true) {
                }
            }
            
        }
        

        
    }
    
 

}
