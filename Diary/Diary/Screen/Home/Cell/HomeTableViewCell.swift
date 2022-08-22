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
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = Constant.Color.black
        view.textAlignment = .left
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = Constant.Color.black
        return view
    }()
    
    private let diaryImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = Constant.Color.black
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
                                titleLabel,
                                dateLabel])
        diaryImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalTo(diaryImageView.snp.trailing).offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(diaryImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set Data
    
    func setupData(data: UserDiary) {
        diaryImageView.image = data.image == nil ?
        UIImage(systemName: "photo") : UIImage(named: data.image!)
        dateLabel.text = "날짜 : " + data.updatedAt!
        titleLabel.text = "제목 : " + data.title
    }
}
