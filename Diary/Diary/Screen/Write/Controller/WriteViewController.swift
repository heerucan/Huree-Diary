//
//  WriteViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

final class WriteViewController: BaseViewController {
    
    // MARK: - Property
    
    private var writerView = WriteView()
    
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
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
    
    @objc func touchupImageButton(_ sender: UIButton) {
        transitionViewController(SearchImageViewController(), .push)
    }
}
