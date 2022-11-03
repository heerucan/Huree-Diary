//
//  TabBarViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/24.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        configureTabBarViewController()
    }
    
    private func configureDelegate() {
        delegate = self
    }

    private func configureTabBarViewController() {
        UITabBar.appearance().scrollEdgeAppearance = tabBar.standardAppearance
        UITabBar.appearance().backgroundColor = .white
        tabBar.tintColor = Constant.Color.point
        
        let firstTabController = UINavigationController(rootViewController: CategoryViewController())
        let secondTabController = UINavigationController(rootViewController: HomeViewController())
        let thirdTabController = UINavigationController(rootViewController: SearchImageViewController())
        let fourthTabController = UINavigationController(rootViewController: SettingViewController())
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "카테고리",
            image: nil,
            selectedImage: nil)
                
        secondTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: nil,
            selectedImage: nil)
                
        thirdTabController.tabBarItem = UITabBarItem(
            title: "통계",
            image: nil,
            selectedImage: nil)
                
        fourthTabController.tabBarItem = UITabBarItem(
            title: "설정",
            image: nil,
            selectedImage: nil)
                
        self.viewControllers = [firstTabController, secondTabController, thirdTabController, fourthTabController]
    }
}
