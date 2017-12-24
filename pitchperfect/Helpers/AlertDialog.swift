//
//  AlertDialog.swift
//  pitchperfect
//
//  Copyright © 2017 Matheus Campos. All rights reserved.
//

import UIKit

class AlertDialog {
    static func showAlert(_ sender: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
