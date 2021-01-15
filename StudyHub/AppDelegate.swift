//
//  AppDelegate.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Debug", ofType: "plist", inDirectory: "Google Plists")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
        else { assert(false, "Couldn't load config file") }
        FirebaseApp.configure(options: fileopts)
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Production", ofType: "plist", inDirectory: "Google Plists")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
        else { assert(false, "Couldn't load config file"); fatalError("Loading Firebase config plist file failed.")}
        FirebaseApp.configure(options: fileopts)
        #endif
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "userID")
        if !(userID?.isEmpty ?? true) {
            let pushManager = PushNotificationManager(userID: userID!)
            pushManager.registerForPushNotifications()
        }
        let un = UNUserNotificationCenter.current()
        un.delegate = self
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: UNUserNotificationDelegate methods
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // do something
        if response.notification.request.identifier == "timerEnded" {
            let notification = Notification(name: .timerEnded, object: nil)
            NotificationCenter.default.post(notification)
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let notification = Notification(name: .timerEnded, object: nil)
        NotificationCenter.default.post(notification)
        
    }
    
}

