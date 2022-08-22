//
//  SearchImageCollectionViewCell.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

import Kingfisher
import SnapKit

class SearchImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    let imageView = UIImageView()
    
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
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set Data
    
    func setupData(imageURL: URL) {
        imageView.kf.setImage(with: imageURL)
    }
}
