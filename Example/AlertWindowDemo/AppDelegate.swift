//
//  AppDelegate.swift
//  AlertWindow
//
//  Created by XiaXianBing on 2016-10-27.
//  Copyright © 2016年 XiaXianBing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
		let navi = UINavigationController(rootViewController: viewController)
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = navi
		self.window?.makeKeyAndVisible()
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
	}
}
