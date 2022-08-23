//
//  WriteViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

import RealmSwift

final class WriteViewController: BaseViewController {
    
    // MARK: - Property
    
    private let writerView = WriteView()
    private let localRealm = try! Realm() // realm 테이블에 데이터를 CRUD할 때, realm 테이블 경로에 접근
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = writerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        writerView.imageButton.addTarget(self, action: #selector(touchupImageButton(_:)), for: .touchUpInside)
        writerView.saveButton.addTarget(self, action: #selector(touchupSaveButton), for: .touchUpInside)
    }
    
    override func configureDelegate() {
        writerView.diaryTextView.delegate = self
    }
    
    // MARK: - Custom Method
    
    func changeTextViewColor() {
        if writerView.diaryTextView.text == Constant.Placeholder.diary.rawValue {
            writerView.diaryTextView.textColor = Constant.Color.placeholder
        } else {
            writerView.diaryTextView.textColor = Constant.Color.black
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupImageButton(_ sender: UIButton) {
        let viewController = SearchImageViewController()
        viewController.imageCompletionHandler = { url in
            self.writerView.photoImageView.kf.setImage(with: url)
        }
        transition(viewController, .push)
    }
    
    @objc func touchupSaveButton() {
        // Create Record
        if let title = writerView.titleTextField.text,
           let content = writerView.diaryTextView.text,
           let updatedAt = writerView.dateTextField.text {
            
            let task = UserDiary(title: title,
                                 content: content,
                                 createdAt: Date(),
                                 updatedAt: Date(),
                                 image: nil)
            
            // 오류를 대응하기 위해서 try
            try! localRealm.write {
                localRealm.add(task)
                print("Realm Succeed")
                dismiss(animated: true)
            }
        } else {
            print("저장안돼?")
        }
    }
}

// MARK: - UITextViewDelegate

extension WriteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Constant.Color.placeholder {
            textView.text = ""
        }
        changeTextViewColor()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.Placeholder.diary.rawValue
        }
        changeTextViewColor()
    }
}
