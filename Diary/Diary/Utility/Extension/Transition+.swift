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
    
    func transition<T: UIViewController>(_ viewController: T,
                                         _ style: TransitionStyle = .present,
                                         completion: ((T) -> Void)? = nil) {
        completion?(viewController)
        
        switch style {
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
