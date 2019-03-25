//
//  Reachability.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Alamofire

struct Reachability {
    
    static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
}
