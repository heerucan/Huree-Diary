//
//  Protocol.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

protocol ReusableViewProtocol {
    static var id: String { get }
}

extension UIViewController: ReusableViewProtocol {
    static var id: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var id: String {
        return String(describing: self)
    }
}
