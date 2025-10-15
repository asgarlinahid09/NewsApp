//
//  BaseTabBarVC.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
class BaseTabBarVC: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeVC()
        home.tabBarItem.image = UIImage(systemName: "house.fill")
        home.title = "Home"
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.navigationBar.isHidden = false
        
        
        let allNews = AllNewsVC()
        allNews.tabBarItem.image = UIImage(systemName: "globe")
        allNews.title = "News"
        let allNewsNav = UINavigationController(rootViewController: allNews)
        allNewsNav.navigationBar.isHidden = false
        
        viewControllers = [homeNav, allNewsNav]
        tabBar.tintColor = .systemRed
    }
}
