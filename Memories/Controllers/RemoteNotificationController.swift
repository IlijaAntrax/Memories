//
//  RemoteNotificationController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

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
        }
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
        
        notificationQuery.setValue(notificationDictionary)
    }
}
