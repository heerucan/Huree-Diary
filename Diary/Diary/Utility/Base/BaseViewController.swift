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
        view.backgroundColor = .white
    }
    
    func configureLayout() { }
    
    func configureDelegate() { }
}
