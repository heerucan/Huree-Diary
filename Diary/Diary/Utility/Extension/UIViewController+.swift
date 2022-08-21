//
//  UIViewController+.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case push
    }
    
    func transitionViewController<T: UIViewController>(_ vc: T,
                                                       _ style: TransitionStyle,
                                                       completion: ((T) -> Void)? = nil) {
        let viewController = vc
        completion?(viewController)

        switch style {
        case .present:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
