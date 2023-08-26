//
//  AppDelegate.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        window.rootViewController = MainViewController()
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
