//
//  WriteView.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import UIKit

class WriteView: BaseView {
    
    // MARK: - Property
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.makeCornerStyle()
        return view
    }()
    
    let imageButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(systemName: Constant.Image.camera.rawValue), for: .normal)
        view.tintColor = .systemGray4
        return view
    }()
    
    let titleTextField = DiaryTextField(.title)
    let dateTextField = DiaryTextField(.date)
    
    let diaryTextView: UITextView = {
        let view = UITextView()
        view.text = Constant.Placeholder.diary.rawValue
        view.textColor = .systemGray3
        view.font = .systemFont(ofSize: 16)
        view.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        view.makeCornerStyle()
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([imageButton,
                          photoImageView,
                          titleTextField,
                          dateTextField,
                          diaryTextView])
                
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(self).multipliedBy(0.4)
        }

        imageButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.top).inset(30)
            make.leading.equalTo(photoImageView.snp.leading).inset(30)
            make.bottom.equalTo(photoImageView.snp.bottom).inset(30)
            make.trailing.equalTo(photoImageView.snp.trailing).inset(30)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        diaryTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
}
