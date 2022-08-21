//
//  UIViewController+.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

extension UIView {
    func addSubviews(_ components: [UIView]) {
        components.forEach { self.addSubview($0) }
    }
}
