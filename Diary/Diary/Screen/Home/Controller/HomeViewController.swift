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
    
    var filterText = "우왕"
    
    let localRealm = try! Realm() // 2. Realm 경로 가져오기
    var tasks: Results<UserDiary>! { // 3. Realm 데이터를 담을 배열 만들기
        didSet { // 해당 프로퍼티의 값이 변화되는 시점마다 테이블뷰가 갱신될 것
            homeTableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    lazy var sortBarButton = UIBarButtonItem(title: "정렬",
                                              style: .done, target: self,
                                              action: #selector(touchupSortBarButton))
    
    lazy var filterBarButton = UIBarButtonItem(title: "필터",
                                              style: .done, target: self,
                                              action: #selector(touchupFilterBarButton))
    
    lazy var plusBarButton = UIBarButtonItem(image: Constant.Image.plus.assets,
                                              style: .done, target: self,
                                              action: #selector(touchupPlusBarButton))
    let homeTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRealmLocalData(keyPath: "title", ascending: true)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "🥳 후리방구 일기장 🍯"
        navigationItem.leftBarButtonItems = [sortBarButton, filterBarButton]
        navigationItem.rightBarButtonItem = plusBarButton
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
    
    func getRealmLocalData(keyPath: String, ascending: Bool) {
        // 4. Realm의 데이터를 정렬해서 배열에 담기
        self.tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    // MARK: - @objc
    
    @objc func touchupSortBarButton() {
        // 데이터가 변화되는 시점마다 테이블뷰가 갱신되어야 한다.
        let alert = UIAlertController(title: "정렬",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let old = UIAlertAction(title: "오래된순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.getRealmLocalData(keyPath: "createdAt", ascending: true)
        }
        let recent = UIAlertAction(title: "최신순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.getRealmLocalData(keyPath: "createdAt", ascending: false)
        }
        let title = UIAlertAction(title: "제목순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.getRealmLocalData(keyPath: "title", ascending: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(old)
        alert.addAction(recent)
        alert.addAction(title)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func touchupFilterBarButton() {
        print("필터버튼")
        // 특정 키워드 기준으로 필터
//        self.tasks = localRealm.objects(UserDiary.self).filter("title = '우왕'")
        
        // 일기를 포함한 문자를 다 가져옴
        // [c] 는 대소문자 여부 상관없이 검색해줌
        self.tasks = localRealm.objects(UserDiary.self).filter("title CONTAINS[c] 'A'")

    }
    
    @objc func touchupPlusBarButton() {
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
