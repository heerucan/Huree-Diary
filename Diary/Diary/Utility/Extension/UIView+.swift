//
//  UIView+.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

extension UIView {
    func addSubviews(_ components: [UIView]) {
        components.forEach { self.addSubview($0) }
    }
    
    func makeCornerStyle(_ width: CGFloat = 2,
                         _ color: CGColor? = Constant.Color.border,
                         _ radius: CGFloat = 10) {
        layer.borderColor = color
        layer.borderWidth = width
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
