//
//  UIViewController+Extensions.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-13.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(with title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach { action in
                alert.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
