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
    let localRealm = try! Realm() // realm 테이블에 데이터를 CRUD할 때, realm 테이블 경로에 접근
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = writerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at:", localRealm.configuration.fileURL!)
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
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
    
    @objc func touchupImageButton(_ sender: UIButton) {
        transitionViewController(SearchImageViewController(), .push)
    }
    
    @objc func touchupSaveButton() {
        // Create Record
        let task = UserDiary(title: "방구뿡방의 일기",
                             content: "RealmStudio 왜 안열려;",
                             createdAt: Date(),
                             updatedAt: Date(),
                             image: nil)
        
        // 오류를 대응하기 위해서 try
        try! localRealm.write {
            localRealm.add(task)
            print("Realm Succeed")
            dismiss(animated: true)
        }
    }
}
