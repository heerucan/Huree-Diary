//
//  BaseViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureDelegate()
    }
    
    // MARK: - Configure UI & Layout
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = Constant.Color.black
        navigationItem.backButtonTitle = ""
        view.backgroundColor = Constant.Color.background
    }
    
    func configureLayout() { }
    func configureDelegate() { }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
