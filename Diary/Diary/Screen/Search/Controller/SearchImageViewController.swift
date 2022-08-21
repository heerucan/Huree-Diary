//
//  SearchImageViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

final class SearchImageViewController: BaseViewController {
    
    // MARK: - Property
    
    private let width = UIScreen.main.bounds.width / 3
    
    lazy var rightBarButton = UIBarButtonItem(title: "선택", style: .done, target: self,
                                              action: #selector(touchupRightBarButton))
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        return layout
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func configureLayout() {
        view.addSubviews([searchBar, collectionView])

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureDelegate() {
        searchBar.delegate = self        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SearchImageCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchImageCollectionViewCell.id)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
    
    @objc func touchupRightBarButton() {
        print("여기서 사진 선택하고 역전달해야 함!")
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCollectionViewCell.id,
                                                            for: indexPath) as? SearchImageCollectionViewCell
        else { return UICollectionViewCell() }
        cell.backgroundColor = .orange
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension SearchImageViewController: UISearchBarDelegate {
    
}
