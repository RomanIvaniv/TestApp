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
private let strBaseURL = "https://api.themoviedb.org/3"

enum MovieDatabaseAPI {
    case movieList
    case movieDetail(Int)
    case movieTrailer(Int)

}

// MARK: - Provider support

extension MovieDatabaseAPI: TargetType {
    var baseURL: URL {
        return URL(string: strBaseURL)!
    }

    var path: String {
        switch self {
        case .movieList:
            return "/movie/popular"
        case .movieDetail(let identifier):
            return "/movie/\(identifier)"
        case .movieTrailer(let identifier):
            return "/movie/\(identifier)/videos"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: ["api_key": apiKey], encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validate: Bool {
        return true
    }
    
    var sampleData: Data {
        //need to provide response samples
        return Data()
    }

}
