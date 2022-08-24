//
//  SettingViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    lazy var backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.addTarget(self, action: #selector(touchupBackupButton(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var restoreButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구하기", for: .normal)
        view.addTarget(self, action: #selector(touchupRestoreButton(_:)), for: .touchUpInside)
        return view
    }()
    
    let lineView = UIView()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "환경설정"
        lineView.backgroundColor = Constant.Color.lightGray
        [backupButton, restoreButton].forEach {
            $0.backgroundColor = Constant.Color.point
            $0.makeCornerStyle()
        }
    }
    
    override func configureLayout() {
        view.addSubviews([backupButton, restoreButton, lineView, tableView])
        
        backupButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(backupButton.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(20)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackupButton(_ sender: UIButton) {
        
    }
    
    @objc func touchupRestoreButton(_ sender: UIButton) {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as? HomeTableViewCell
        else { return UITableViewCell() }
        cell.titleLabel.text = "TEST"
        return cell
    }
}
