//
//  AppDelegate.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let moviesViewController = MoviesViewController()
        moviesViewController.viewModel = MoviesViewModel()
        window?.rootViewController = UINavigationController(rootViewController: moviesViewController)
        window?.makeKeyAndVisible()
        return true
    }


}

