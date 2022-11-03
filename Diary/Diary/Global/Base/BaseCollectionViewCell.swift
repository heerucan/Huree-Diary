//
//  BaseCollectionViewCell.swift
//  Diary
//
//  Created by heerucan on 2022/11/03.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, BaseViewMethodType {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.backgroundColor = .white
    }
    
    func configureLayout() { }
    func setupDelegate() { }
}

