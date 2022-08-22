//
//  SearchImageViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

final class SearchImageViewController: BaseViewController {
    
    // MARK: - Property
    
    private var page = 1
    private var searchPage = 1
    private var imageList: [URL] = []
    private var index = 0
    
    var imageCompletionHandler: ((URL) -> ())?
    
    lazy var rightBarButton = UIBarButtonItem(
        title: "선택",
        style: .done,
        target: self,
        action: #selector(touchupRightBarButton))
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = Constant.Placeholder.searchBar.rawValue
        view.tintColor = Constant.Color.point
        return view
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    let layout: UICollectionViewFlowLayout = {
        let width = UIScreen.main.bounds.width / 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        return layout
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestImage()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "오늘의 사진 검색"
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
        collectionView.prefetchDataSource = self
        collectionView.register(
            SearchImageCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchImageCollectionViewCell.id)
    }
    
    // MARK: - @objc
    
    @objc func touchupRightBarButton() {
        imageCompletionHandler?(imageList[index])
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCollectionViewCell.id, for: indexPath) as? SearchImageCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupData(imageURL: imageList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        print(imageList[indexPath.item])
        index = indexPath.item
        
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension SearchImageViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item {
                if searchBar.text! == "" {
                    page += 50
                    requestImage()
                } else {
                    searchPage += 50
                    requestSearchImage(query: searchBar.text!)
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchImageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            imageList.removeAll()
            searchPage = 1
            requestSearchImage(query: text)
        } else {
            imageList.removeAll()
            page = 1
            requestImage()
            searchBar.text = ""
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        imageList.removeAll()
        page = 1
        requestImage()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

// MARK: - Network

extension SearchImageViewController {
    func requestImage() {
        ImageManager.shared.requestImage(page: page) { [weak self] (list) in
            guard let self = self else { return }
            self.imageList.append(contentsOf: list)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func requestSearchImage(query: String) {
        ImageManager.shared.requestSearch(page: searchPage, query: query) { [weak self] (list) in
            guard let self = self else { return }
            self.imageList.append(contentsOf: list)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
