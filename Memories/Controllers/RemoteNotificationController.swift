//
//  RemoteNotificationController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UserNotifications

enum ActionType:String
{
    case none = "none"
    case showAlbum = "showAlbum"
    case showPhoto = "showPhoto"
    case showSharedAlbums = "showSharedAlbums"
    case showMyAlbums = "showMyAlbums"
}

class RemoteNotificationController:FirebaseController
{
    //READ
    static func getToken(forUserId userId:String, completitionHandler:@escaping(String) -> ())
    {
        let tokenQuery = dbRef.child(k_db_notifications).child(userId).child(k_NOTIFICATION_TOKEN)
        tokenQuery.observe(.value) { (dataSnapshot) in
            if let token = dataSnapshot.value as? String
            {
                completitionHandler(token)
            }
        }
    }
    
    static func getNotifications(forUserId userId:String, completionHandler:@escaping ([RemoteNotification]) -> ())
    {
        let notificationQuery = dbRef.child(k_db_notifications).child(userId).child(k_NOTIFICATION_ARRAY)
        notificationQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let notificationsArray = dataSnapshot.value as? NSDictionary
            {
                var notifications = [RemoteNotification]()
                for notificationKey in notificationsArray.allKeys
                {
                    notifications.append(RemoteNotification.initWith(key: notificationKey as! String, dictionary: notificationsArray[notificationKey] as! NSDictionary))
                }
                completionHandler(notifications)
            }
            else
            {
                completionHandler([RemoteNotification]())
            }
        }
    }
    
    static func getUnreadNotifications(forUserID userId:String, completionHandler:@escaping ([RemoteNotification]) -> ())
    {
        let notifQuery = dbRef.child(k_db_notifications).child(userId).child(k_NOTIFICATION_ARRAY).queryOrdered(byChild: k_NOTIFICATION_READ).queryEqual(toValue: false)
        notifQuery.observeSingleEvent(of: .value) { (snapshot) in
            if let notificationsArray = snapshot.value as? NSDictionary
            {
                var notifications = [RemoteNotification]()
                for notificationKey in notificationsArray.allKeys
                {
                    notifications.append(RemoteNotification.initWith(key: notificationKey as! String, dictionary: notificationsArray[notificationKey] as! NSDictionary))
                }
                completionHandler(notifications)
            }
        }
    }
    
    static func markAsReadNotification(_ notification:RemoteNotification, forUserID userID:String)
    {
        let notificationQuery = dbRef.child(k_db_notifications).child(userID).child(k_NOTIFICATION_ARRAY).child(notification.ID).child(k_NOTIFICATION_READ)
        
        notificationQuery.setValue(true)
    }
    
    //WRITE
    static func setToken(token: String, forUser user:User)
    {
        let tokenQuery = dbRef.child(k_db_notifications).child(user.ID).child(k_NOTIFICATION_TOKEN)
        
        tokenQuery.setValue(token)
    }
    
    static func addNotification(notification:RemoteNotification, forUser user:User)
    {
        let notificationQuery = dbRef.child(k_db_notifications).child(user.ID).child(k_NOTIFICATION_ARRAY).childByAutoId()
        
        let notificationDictionary = NSMutableDictionary()
        notificationDictionary.setValue(notification.messageTitle, forKey: k_NOTIFICATION_TITLE)
        notificationDictionary.setValue(notification.messageBody, forKey: k_NOTIFICATION_BODY)
        notificationDictionary.setValue(notification.date.getString(), forKey: k_NOTIFICATION_DATE)
        notificationDictionary.setValue(notification.actionType.rawValue, forKey: k_NOTIFICATION_ACTION)
        notificationDictionary.setValue(notification.objectActionId, forKey: k_NOTIFICATION_OBJECT)
        notificationDictionary.setValue(notification.readStatus, forKey: k_NOTIFICATION_READ)
        
        notificationQuery.setValue(notificationDictionary)
    }
    
    static func scheduleNotification(_ notification:RemoteNotification)
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notification.messageTitle
        notificationContent.body = notification.messageBody
        notificationContent.badge = 1
        notificationContent.categoryIdentifier = notification.actionType.rawValue
        
        let notificationTriger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: "notificationMemories", content: notificationContent, trigger: notificationTriger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            print(error as Any)
        }
    }
}
