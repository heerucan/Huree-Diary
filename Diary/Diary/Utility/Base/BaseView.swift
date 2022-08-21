//
//  BaseView.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

import SnapKit

class BaseView: UIView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    func configureUI() { }
    func configureLayout() { }
}
