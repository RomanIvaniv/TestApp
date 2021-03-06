//
//  MovieListItem.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

private let imageSize = 342 //"w92", "w154", "w185", "w342", "w500", "w780"
private let baseImagePath = "http://image.tmdb.org/t/p/w\(imageSize)"

//we could use Codable protocol to parse JSON, but in our case it's overload

struct MovieItem {
    var uniqueID: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseData: String?
    
    var genres: [String]? 

    var imageURL: URL? {
        guard let imgPath = posterPath else { return nil }
        let fullPath = baseImagePath + imgPath
        return URL(string: fullPath)
    }
    
    static func createMovies(from data: [String: Any]) -> [MovieItem] {
        var movies = [MovieItem]()
        if let items = data["results"] as? [[String: Any]] {
            items.forEach { movies.append(MovieItem(data: $0)) }
        }
        return movies
    }
    
    init(data: [String: Any]) {
        self.uniqueID = data["id"] as? Int
        self.title = data["title"] as? String
        self.overview = data["overview"] as? String
        self.posterPath = data["poster_path"] as? String
        self.releaseData = data["release_date"] as? String
        
        if let genreIds = data["genre_ids"] as? [Int] {
            self.genres = genreIds.map { String($0) }
        }
    }

}
