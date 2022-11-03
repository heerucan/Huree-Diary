//
//  BaseView.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

class BaseView: UIView, BaseViewMethodType {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureUI() {
        backgroundColor = .white
    }
    
    func configureLayout() { }
    func setupDelegate() { }
    func bindViewModel() { }
}
