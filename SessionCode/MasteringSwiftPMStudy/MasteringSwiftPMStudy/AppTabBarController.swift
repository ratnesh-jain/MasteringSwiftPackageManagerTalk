//
//  AppTabBarController.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import Foundation
import UIKit
import CommentsFeature
import CommentSwiftUIFeature
import SwiftUI

class AppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        let postViewController = PostViewController()
        let postNavigationController = UINavigationController(rootViewController: postViewController)
        postNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let usersViewController = UsersViewController()
        let usersNavigationController = UINavigationController(rootViewController: usersViewController)
        usersNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        // let commentsViewController = CommentsViewController()
        let commentsViewController = UIHostingController(rootView: CommentsView())
        let commentsNavigationController = UINavigationController(rootViewController: commentsViewController)
        commentsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)

        self.viewControllers = [
            postNavigationController,
            usersNavigationController,
            commentsNavigationController
        ]
    }
}
