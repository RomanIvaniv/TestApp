//
//  MovieDatabaseAPI.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Moya
import Foundation

private let strBaseURL = "https://staging.fragusonline.se"

enum MovieDatabaseAPI {
    case movieList

}

// MARK: - Provider support

extension MovieDatabaseAPI: TargetType {

}
