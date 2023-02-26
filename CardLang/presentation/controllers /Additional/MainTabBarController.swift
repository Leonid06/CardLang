//
//  MainTabBarController.swift
//  CardLang
//
//  Created by Leonid on 26.02.2023.
//

import UIKit


class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        let homeViewController = HomeViewController()
        
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "house.circle"), tag: 0)
        viewControllers?.append(homeViewController)
    }
}
