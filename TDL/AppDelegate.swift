//
//  AppDelegate.swift
//  TDL
//
//  Created by Janusz Marcinkiewicz on 23.08.2014.
//  Copyright (c) 2014 VirrageS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = UINavigationController(rootViewController: ListViewController())
        window.makeKeyAndVisible()
        return true
    }
}
