//
//  AlertController.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/23/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit

struct AlertController {
    
    static func showErrorAlert(with message: String?, target: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        target.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(title: String?, message: String?, target: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        target.present(alert, animated: true, completion: nil)
    }
    
}
