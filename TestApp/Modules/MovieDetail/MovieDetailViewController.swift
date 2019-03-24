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
import SVProgressHUD

enum ActivityIndicatorType {
    case genres
    case trailers
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var downloadBarButton: UIBarButtonItem!
    @IBOutlet weak var genresActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var trailerActivityIndicator: UIActivityIndicatorView!
    
    let presenter = MovieDetailPresenter()
    
    lazy var playerViewController = AVPlayerViewController()

    var movie: MovieItem? {
        didSet {
            guard isViewLoaded else { return } //handle set from segue
            updateUI()
        }
    }
    
    private var hasMovie: Bool {
        return movie != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        presenter.attachView(view: self)
        presenter.loadDetail(for: movie)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closePlayer), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func updateUI() {
        scrollView.isHidden = !hasMovie //hide while no data (for iPad)
        
        titleLabel.text = movie?.title
        dateLabel.text = movie?.releaseData
        overviewLabel.text = movie?.overview
        genreLabel.text = movie?.genres?.joined(separator: ", ")
        downloadBarButton.isEnabled = !presenter.hasLocalTrailer(for: movie)
        iconImageView.sd_setImage(with: movie?.imageURL, placeholderImage: #imageLiteral(resourceName: "bike"))
    }
    
    // MARK: - Actions
    
    @IBAction func watchTrailerAction(_ sender: UIButton) {
        guard let movie = movie else { return }
        presenter.watchTrailer(for: movie)
    }
    
    @IBAction func downloadBtnAction(_ sender: UIBarButtonItem) {
        presenter.downloadTrailer(for: movie)
    }
    
    // MARK: - Notifications
    
    @objc func closePlayer() {
        DispatchQueue.main.async {
            self.playerViewController.dismiss(animated: true)
        }
    }
    
}

extension MovieDetailViewController: MovieDetailView {
    
    func updateNavBarItem() {
        DispatchQueue.main.async {
            self.downloadBarButton.isEnabled = !self.presenter.hasLocalTrailer(for: self.movie)
        }
    }
    
    func setMovie(_ movie: MovieItem) {
        self.movie = movie
    }
    
    func showError(with message: String?) {
        AlertController.showErrorAlert(with: message, target: self)
    }
    
    func showAlert(title: String?, message: String?) {
        AlertController.showAlert(title: title, message: message, target: self)
    }
    
    func hideLoaderIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func showLoaderIndicator(with message: String?) {
        SVProgressHUD.show(withStatus: message)
    }
    
    func playTrailer(url: URL) {
        DispatchQueue.main.async {
            let player = AVPlayer(url:url)
            self.playerViewController.player = player
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
        }
    }
    
    func showActivityIndicator(for type: ActivityIndicatorType) {
        DispatchQueue.main.async {
            switch type {
            case .genres:
                self.genresActivityIndicator.startAnimating()
            case .trailers:
                self.trailerButton.isEnabled = false
                self.trailerActivityIndicator.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator(for type: ActivityIndicatorType) {
        DispatchQueue.main.async {
            switch type {
            case .genres:
                self.genresActivityIndicator.stopAnimating()
            case .trailers:
                self.trailerButton.isEnabled = true
                self.trailerActivityIndicator.stopAnimating()
            }
        }
    }
        
}
