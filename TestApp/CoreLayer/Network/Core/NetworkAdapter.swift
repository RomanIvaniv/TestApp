//
//  NetworkAdapter.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Moya
import Alamofire
import Foundation
import enum Result.Result

typealias RequestCompletion = (_ result: Any?, _ error: String?) -> Void

private let requestsTimeoutInSec: TimeInterval = 10

let MoviewProvider = MoyaProvider<MovieDatabaseAPI>(requestClosure: requestClosure)

let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        let request = try endpoint.urlRequest()
        // Modify the request however you like.
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

let manager: Manager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = requestsTimeoutInSec
    
    let manager = Manager(configuration: configuration)
    return manager
}()

let networkActivityPlugin = NetworkActivityPlugin { type, _ in
    switch type {
    case .began: UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended: UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

struct ResponseHandler {
    static func handle(result: Result<Response, MoyaError>, completion: ([String: Any]?, String?) -> Void) {
        switch result {
        case let .success(response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes()
                let result = try successResponse.mapJSON() as? [String: Any]
                completion(result, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        case let .failure(error):
            completion(nil, error.errorDescription ?? "Something went wrong")
        }
    }
}
