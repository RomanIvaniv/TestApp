//
//  MovieService.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

protocol MovieService {

    func movieList(completion: @escaping RequestCompletion)
    func movieDatail(for movie: MovieListItem, completion: @escaping RequestCompletion)
    func movieTrailers(for movie: MovieListItem, completion: @escaping RequestCompletion)
    
}
