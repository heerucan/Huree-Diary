//
//  HomeViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import UIKit

import RealmSwift // 1. import

final class HomeViewController: BaseViewController {
    
    // MARK: - Property
    
    let localRealm = try! Realm() // 2. Realm 경로 가져오기
    var tasks: Results<UserDiary>! // 3. Realm 데이터를 담을 배열 만들기
    
    lazy var rightBarButton = UIBarButtonItem(image: Constant.Image.plus.assets,
                                              style: .done, target: self,
                                              action: #selector(touchupRightBarButton))
    let homeTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 90
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRealmLocalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "createdAt", ascending: false)
        homeTableView.reloadData()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "🥳 후리방구 일기장 🍯"
        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func configureLayout() {
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureDelegate() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
    }
    
    // MARK: - Custom Method
    
    func getRealmLocalData() {
        // 4. Realm의 데이터를 정렬해서 배열에 담기
        let tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "createdAt", ascending: false)
        self.tasks = tasks
        print(tasks)
    }
    
    // MARK: - @objc
    
    @objc func touchupRightBarButton() {
        let viewController = UINavigationController(rootViewController: WriteViewController())
        transition(viewController)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as? HomeTableViewCell
        else { return UITableViewCell() }
        cell.setupData(data: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
