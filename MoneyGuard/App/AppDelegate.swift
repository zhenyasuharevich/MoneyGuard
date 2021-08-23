//
//  AppDelegate.swift
//  MoneyGuard
//
//  Created by Zhenya Suharevich on 27.07.2021.
//

import UIKit
@_exported import RealmSwift
@_exported import Realm

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { return true }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration { return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role) }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

}

