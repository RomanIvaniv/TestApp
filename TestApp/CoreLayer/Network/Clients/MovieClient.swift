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
                    items.forEach { movies.append(MovieListItem(data: $0)) }
                }
                completion(movies, nil)
            })
        }
    }
    
    func movieDatail(for movie: MovieListItem, completion: @escaping RequestCompletion) {
        MoviewProvider.request(.movieDetail(movie.uniqueID!)) { (result) in
            ResponseHandler.handle(result: result, completion: { (dict, error) in
                guard let resp = dict else {
                    completion(nil, error!)
                    return
                }
                var mutatedMovie = movie
                if let genresItems = resp["genres"] as? [[String: Any]] {
                    let genresNames = genresItems.map { $0["name"] as? String ?? ""}
                    mutatedMovie.genres = genresNames
                }
                completion(mutatedMovie, nil)
            })
        }
    }
    
    func movieTrailers(for movie: MovieListItem, completion: @escaping RequestCompletion) {
        MoviewProvider.request(.movieTrailer(movie.uniqueID!)) { (result) in
            ResponseHandler.handle(result: result, completion: { (dict, error) in
                guard let resp = dict else {
                    completion(nil, error!)
                    return
                }
                var trailers = [String]()
                if let genresItems = resp["results"] as? [[String: Any]] {
                    genresItems.forEach {
                        if let key = $0["key"] as? String, let site =  $0["site"] as? String, site == "YouTube" {
                            let baseYoutube = "https://www.youtube.com/watch?v="
                            let path = baseYoutube + key
                            trailers.append(path)
                        }
                    }
                }
                completion(trailers, nil)
            })
        }
    }
    
}
