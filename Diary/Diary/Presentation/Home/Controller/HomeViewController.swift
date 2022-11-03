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
    
    // MARK: - Realm
    
    let repository = UserDiaryRepository() // 2. Realm 경로 가져오기
    var tasks: Results<UserDiary>! { // 3. Realm 데이터를 담을 배열 만들기
        didSet { // 해당 프로퍼티의 값이 변화되는 시점마다 테이블뷰가 갱신될 것
            homeTableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    // MARK: - Property
    
    // UIMenu
    var menuItems: [UIAction] {
        return [recentMenu, oldMenu, titleMenu, favoriteMenu, filterMenu]
    }
    
    var menu: UIMenu {
        return UIMenu(title: "정렬 및 검색", children: menuItems)
    }
    
    lazy var recentMenu = UIAction(title: "최신순") { _ in
        self.fetchRealmData("createdAt", false)
    }
    
    lazy var oldMenu = UIAction(title: "오래된순") { _ in
        self.fetchRealmData()
    }
    
    lazy var titleMenu = UIAction(title: "제목순") { _ in
        self.fetchRealmData("title", true)
    }
    
    lazy var favoriteMenu = UIAction(title: "즐겨찾기순", image: Constant.Image.heart.assets) { _ in
        self.fetchRealmData("favorite", false)
    }
    
    lazy var filterMenu = UIAction(title: "키워드 검색", image: Constant.Image.filter.assets) { _ in
        let alert = UIAlertController(title: "키워드 검색", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = Constant.Placeholder.filter.rawValue
        }
        
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            guard let textFields = alert.textFields else { return }
            guard let text = textFields[0].text else { return }
            //특정 키워드 기준으로 필터해주고, ' ' 따옴표가 있어야 한다.
            self.tasks = self.repository.fetchFilter(query: text)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
        /* [c] 는 대소문자 여부 상관없이 검색해줌
         self.tasks = self.localRealm.objects(UserDiary.self).filter("title CONTAINS[c] 'A'")
         = 은 무조건 같아야만 검색해줌
         self.tasks = self.localRealm.objects(UserDiary.self).filter("title = 'A'")
         */
    }
    
    lazy var leftBarButton = UIBarButtonItem(image: Constant.Image.menu.assets,
                                             primaryAction: nil,
                                             menu: menu)
    
    lazy var plusBarButton = UIBarButtonItem(image: Constant.Image.plus.assets,
                                             style: .done, target: self,
                                             action: #selector(touchupPlusBarButton))
    
    lazy var homeTableView: UITableView = {
        let view = UITableView()
        view.rowHeight = UITableView.automaticDimension
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        fetchRealmData()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "옷장연습"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = plusBarButton
    }
    
    override func configureLayout() {
        view.addSubviews([homeTableView])
        
        homeTableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Custom Method
    
    // 4. Realm의 데이터를 정렬해서 배열에 담기
    func fetchRealmData(_ keyPath: String = "createdAt", _ ascending: Bool = true) {
        self.tasks = repository.fetch(keyPath: keyPath, ascending: ascending)
    }
    
    // MARK: - @objc
    
    @objc func touchupPlusBarButton() {
        let viewController = WriteViewController()
        transition(viewController, .presentFullNavigation)
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
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = WriteViewController()
        transition(viewController, .presentFullNavigation) { viewController in
            viewController.viewType = .Edit
            viewController.objectId = self.tasks[indexPath.row].objectId
            viewController.writerView.setupData(data: self.tasks[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            repository.deleteItem(item: tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            
            /* 여기서도 didSet으로 프로퍼티가 변경 시마다 reload해주기 때문에 아래 코드는 주석처리해도 된다.
             
             하나의 record에서 하나만 reload하니까 상대적으로 효율적임 -> 이게 좀 더 스무스하긴 하네.. 내 취향이네..
            // self.homeTableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            
             데이터가 변경됐으니 다시 realm에서 데이터를 가지고 오기 => didSet 일관적 형태로 갱신
            // self.fetchRealmData() */
        }
        
        // realm 데이터 기준으로 이미지 변경
        let image = tasks[indexPath.row].favorite ? "heart.fill" : "heart"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}
