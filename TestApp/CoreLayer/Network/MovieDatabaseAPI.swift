//
//  MovieDatabaseAPI.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Moya
import Foundation

private let apiKey = "628a9c80740fccbc8a67ce27b3e07930"
private let strBaseURL = "https://api.themoviedb.org/3/movie"

enum MovieDatabaseAPI {
    case movieList

}

// MARK: - Provider support

extension MovieDatabaseAPI: TargetType {
    var baseURL: URL {
        return URL(string: strBaseURL)!
    }

    var path: String {
        switch self {
        case .movieList:
            return "/popular?api_key=​\(apiKey)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .movieList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .movieList:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .movieList:
            return ["Content-Type": "application/json"]
        }
    }
    
    var sampleData: Data {
        //need to provide response samples
        return Data()
    }

}
