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
import YoutubeDirectLinkExtractor

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    var movie: MovieListItem!
    
    let movieService: MovieService = MovieClient()


    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
            let y = YoutubeDirectLinkExtractor()
            y.extractInfo(for: .urlString(firstTrailer), success: { info in
                let player = AVPlayer(url: URL(string: info.highestQualityPlayableLink!)!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }) { error in
                print(error)
            }
            
        }
        

        
    }
    
 

}
