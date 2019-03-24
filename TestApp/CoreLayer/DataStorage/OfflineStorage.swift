//
//  DataStorage.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

private let movieListKey = "MovieList"

struct OfflineStorage {
    
    static func save(data: [String: Any]) {
        UserDefaults.standard.setValue(data, forKey: movieListKey)
    }
    
    static func loadMovies() -> [MovieItem]? {
        guard let data = UserDefaults.standard.value(forKey: movieListKey) as? [String: Any] else {
            return nil
        }
        let movies = MovieItem.createMovies(from: data)
        return movies
    }
    
}
