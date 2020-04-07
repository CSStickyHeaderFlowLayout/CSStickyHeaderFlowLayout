//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by James Tang on 16/7/15.
//  Copyright (c) 2015 James Tang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.

        let stickyHeaderFlowLayout = CSStickyHeaderFlowLayout()
        let collectionViewController = CollectionViewController(collectionViewLayout: stickyHeaderFlowLayout)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = collectionViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

