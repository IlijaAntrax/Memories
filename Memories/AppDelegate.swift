//
//  AppDelegate.swift
//  Memories
//
//  Created by Ilija Antonijevic on 11/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        MyAccount.sharedInstance.token = "-L1_wSB-uSDDF2fRCfcA23y"
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        //Specify request for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (permissionGranted, error) in
            
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        //Set notifications categories
        let photoAction = UNNotificationAction(identifier: ActionType.showPhoto.rawValue, title: "Show photo", options: [.foreground])
        let photoCategory = UNNotificationCategory(identifier: ActionType.showPhoto.rawValue, actions: [photoAction], intentIdentifiers: [], options: [])
        
        let sharedAlbumsAction = UNNotificationAction(identifier: ActionType.showSharedAlbums.rawValue, title: "Show shared album", options: [.foreground])
        let sharedAlbumsCategory = UNNotificationCategory(identifier: ActionType.showSharedAlbums.rawValue, actions: [sharedAlbumsAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([photoCategory, sharedAlbumsCategory])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let userID = KeychainService.loadPassword(service: kSecService, account: kSecAccount)
        {
            RemoteNotificationController.getUnreadNotifications(forUserID: userID) { (notifications) in
                if notifications.count > 0
                {
                    for notification in notifications
                    {
                        RemoteNotificationController.scheduleNotification(notification)
                        RemoteNotificationController.markAsReadNotification(notification, forUserID: userID)
                    }
                    completionHandler(.newData)
                }
                else
                {
                    completionHandler(.noData)
                }
            }
        }
        else
        {
            completionHandler(.noData)
        }
    }

    //MARK: UNUserNotificationDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0;
        if response.actionIdentifier == ActionType.showSharedAlbums.rawValue
        {
            print("Show shared album.")
        }
        else if response.actionIdentifier == ActionType.showAlbum.rawValue
        {
            print("Show album, shared or my album.")
        }
    }
}

