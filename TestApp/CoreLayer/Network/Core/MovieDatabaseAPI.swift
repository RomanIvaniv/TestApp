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
            return "/popular"
        }
    }

    var method: Moya.Method {
        switch self {
        case .movieList:
            return .get
        }
    }

    var task: Task {
        let apiKeyParam = ["api_key": apiKey]
        
        switch self {
        case .movieList:
            return .requestParameters(parameters: apiKeyParam, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .movieList:
            return ["Content-Type": "application/json"]
        }
    }
    
    var validate: Bool {
        return true
    }
    
    var sampleData: Data {
        //need to provide response samples
        return Data()
    }

}
