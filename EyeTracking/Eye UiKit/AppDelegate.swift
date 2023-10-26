//
//  AppDelegate.swift
//  Eye Tracking
//
//  Created by Marcelo De Araújo on 26/10/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()

        window?.rootViewController = ARSCNViewController()

        return true
    }
}
