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
        
        let firstTabController = UINavigationController(rootViewController: HomeViewController())
        let secondTabController = UINavigationController(rootViewController: SettingViewController())
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "",
            image: Constant.Image.unselectedHome.assets,
            selectedImage: Constant.Image.selectedHome.assets)
        
        secondTabController.tabBarItem = UITabBarItem(
            title: "",
            image: Constant.Image.unselectedSetting.assets,
            selectedImage: Constant.Image.selectedSetting.assets)
        
        self.viewControllers = [firstTabController, secondTabController]
    }
}
