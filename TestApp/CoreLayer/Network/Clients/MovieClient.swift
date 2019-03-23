//
//  MovieClient.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

struct MovieClient: MovieService {
    
    func movieList(completion: @escaping RequestCompletion) {
        MoviewProvider.request(.movieList) { (result) in
            ResponseHandler.handle(result: result, completion: { (dict, error) in
                guard let resp = dict else {
                    completion(nil, error!)
                    return
                }
                var movies = [MovieListItem]()
                if let items = resp["results"] as? [[String: Any]] {
                    items.forEach {
                        let movie = MovieListItem(title: $0["title"] as? String, imagePath: $0["poster_path"] as? String)
                        movies.append(movie)
                    }
                }
                completion(movies, nil)
            })
        }
    }
    
}
