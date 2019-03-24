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
    
    init(data: [String: Any]) {
        self.uniqueID = data["id"] as? Int
        self.title = data["title"] as? String
        self.overview = data["overview"] as? String
        self.posterPath = data["poster_path"] as? String
        self.releaseData = data["release_date"] as? String
    }
}
