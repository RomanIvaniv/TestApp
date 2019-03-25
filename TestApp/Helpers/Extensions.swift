//
//  UISearchBar+Deactivate.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func deactivate(animated: Bool = true) {
        resignFirstResponder()
        setShowsCancelButton(false, animated: animated)
    }
    
}
