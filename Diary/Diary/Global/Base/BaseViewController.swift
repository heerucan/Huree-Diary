//
//  BaseViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

class BaseViewController: UIViewController, BaseViewMethodType {
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    // MARK: - Configure UI & Layout
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureLayout() { }
    func setupDelegate() { }
    func bindViewModel() { }
}
