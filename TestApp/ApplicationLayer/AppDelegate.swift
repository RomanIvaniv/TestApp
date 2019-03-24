//
//  AppDelegate.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/22/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        return true
    }

}

