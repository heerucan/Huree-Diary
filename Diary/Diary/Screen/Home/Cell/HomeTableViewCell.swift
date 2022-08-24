//
//  HomeTableViewCell.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

import SnapKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = Constant.Color.black
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = Constant.Color.black
        view.textAlignment = .left
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = Constant.Color.black
        view.textAlignment = .left
        return view
    }()
    
    let diaryImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = Constant.Color.point
        view.tintColor = Constant.Color.background
        view.makeCornerStyle()
        return view
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureLayout() {
        contentView.addSubviews([diaryImageView,
                                 dateLabel,
                                 titleLabel,
                                 contentLabel])
        diaryImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryImageView.snp.top).inset(9)
            make.leading.equalTo(diaryImageView.snp.trailing).offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(diaryImageView.snp.centerY)
            make.leading.equalTo(diaryImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(diaryImageView.snp.trailing).offset(15)
            make.bottom.equalTo(diaryImageView.snp.bottom).inset(6)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set Data
    
    func setupData(data: UserDiary) {
        dateLabel.text = data.updatedAt
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
}
