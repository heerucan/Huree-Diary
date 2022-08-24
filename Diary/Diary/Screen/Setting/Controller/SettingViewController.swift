//
//  SettingViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    let backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.backgroundColor = Constant.Color.point
        view.makeCornerStyle()
        return view
    }()
    
    let backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.backgroundColor = Constant.Color.point
        view.makeCornerStyle()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .blue
        navigationItem.title = "환경설정"
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    

    
}
