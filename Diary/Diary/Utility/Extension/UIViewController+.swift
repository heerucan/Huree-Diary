//
//  UIViewController+.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String,
                   _ message: String? = nil,
                   _ preferredStyle: UIAlertController.Style,
                   buttonTitle: String,
                   buttonAction: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: buttonAction)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
