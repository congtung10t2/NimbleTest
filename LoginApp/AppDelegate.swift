//
//  AppDelegate.swift
//  LoginApp
//
//  Created by tungaptive on 29/11/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var rootViewController: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13, *) {
            // Code to be executed if the iOS version is 11 or newer
        } else {
            AutoRefreshToken.shared.startTokenRefresh()
            if TokenManager.shared.getAccessToken() != nil || TokenManager.shared.getRefreshToken() != nil {
                rootViewController = HomeViewController()
            } else {
                rootViewController = LoginViewController(viewModel: LoginViewModel())
            }
            self.window = UIWindow()
            self.window?.bounds = UIScreen.main.bounds
            self.window?.rootViewController = rootViewController
            self.window?.backgroundColor = .white
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

