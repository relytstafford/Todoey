//
//  AppDelegate.swift
//  Todoey
//
//  Created by Ty Stafford on 6/29/18.
//  Copyright © 2018 Tyler Stafford. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
             _ = try Realm()
           
        } catch {
            print("Error initalising new realm, \(error)")
        }
        
        
        return true
    }

}

