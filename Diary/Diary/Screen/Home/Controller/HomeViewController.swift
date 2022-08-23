//
//  HomeViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import UIKit

import RealmSwift // 1. import
import Kingfisher

final class HomeViewController: BaseViewController {
    
    // MARK: - Property
        
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
        fetchRealmData(keyPath: "title", ascending: true)
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
    
    func fetchRealmData(keyPath: String = "createdAt", ascending: Bool = false) {
        // 4. Realm의 데이터를 정렬해서 배열에 담기
        self.tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    // MARK: - @objc
    
    @objc func touchupSortBarButton() {
        // 데이터가 변화되는 시점마다 테이블뷰가 갱신되어야 한다. -> 매번 해주는 것보다 tasks에 프로퍼티 옵저버로 해주자!
        let alert = UIAlertController(title: "정렬",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let old = UIAlertAction(title: "오래된순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.fetchRealmData(keyPath: "createdAt", ascending: true)
        }
        let recent = UIAlertAction(title: "최신순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.fetchRealmData(keyPath: "createdAt", ascending: false)
        }
        let title = UIAlertAction(title: "제목순", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.fetchRealmData(keyPath: "title", ascending: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(old)
        alert.addAction(recent)
        alert.addAction(title)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func touchupFilterBarButton() {
        /* 특정 키워드(우왕) 기준으로 필터해주고, ' ' 따옴표가 있어야 한다.
         self.tasks = localRealm.objects(UserDiary.self).filter("title = '우왕'")
         [c] 는 대소문자 여부 상관없이 검색해줌 */
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
    
    // TableView Editing Mode
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let star = UIContextualAction(style: .normal, title: "⭐️") { _, _, completion in
            completion(true)
        }
        star.backgroundColor = Constant.Color.point
        return UISwipeActionsConfiguration(actions: [star])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            // realm update
            try! self.localRealm.write{
                /* 이거는 하나만 바뀜
                 self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite */
                
                /* 하나의 테이블에 특정 컬럼 전체를 변경
                 => 하나만 바꾸면 다른 것도 다 바뀜
                 self.tasks.setValue(true, forKey: "favorite") */
                
                /* 하나의 레코드에서 여러 컬럼들이 변경
                 => 루희야 이거 컬럼이야! 다른 레코드가 아님! 컬럼들이 바뀐다고!! */
                self.localRealm.create(UserDiary.self,
                                       value: [
                                        "objectId": self.tasks[indexPath.row].objectId,
                                        "content": "내용 변경 테스트",
                                        "title": "제목 변경 테스트"],
                                       update: .modified)
            }
            
            // 하나의 record에서 하나만 reload하니까 상대적으로 효율적임 -> 이게 좀 더 스무스하긴 하네.. 내 취향이네..
            self.homeTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            /* 데이터가 변경됐으니 다시 realm에서 데이터를 가지고 오기 => didSet 일관적 형태로 갱신
             self.fetchRealmData() */
        }
        
        // realm 데이터 기준으로 이미지 변경
        let image = tasks[indexPath.row].favorite ? "heart.fill" : "heart"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}
