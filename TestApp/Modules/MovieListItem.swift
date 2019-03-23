//
//  MovieListItem.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

private let imageSize = 92
private let baseImagePath = "http://image.tmdb.org/t/p/w\(imageSize)"

struct MovieListItem {
    
    var title: String?
    var imagePath: String?
    
    var imageURL: URL? {
        guard let imgPath = imagePath else { return nil }
        let fullPath = baseImagePath + imgPath
        return URL(string: fullPath)
    }
    
}
