//
//  MainTabBarViewController.swift
//  tbcac
//
//  Created by user on 11/11/23.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarViews()
    }
    
    private func setUpTabBarViews() {
        let viewControllers: [UIViewController] = [
            createTabBarItem(viewController: HomeViewController(), imageName: "house", title: "Home"),
            createTabBarItem(viewController: UpcomingViewController(), imageName: "play.circle", title: "Coming Soon"),
            createTabBarItem(viewController: SearchViewController(), imageName: "magnifyingglass", title: "Top Search"),
            createTabBarItem(viewController: DownloadsViewController(), imageName: "arrow.down.to.line", title: "Downloads")
        ]
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func createTabBarItem(viewController: UIViewController, imageName: String, title: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.title = title
        return navController
    }
}

