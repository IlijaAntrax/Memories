//
//  RemoteNotification.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

let k_NOTIFICATION_ARRAY = "notification"
let k_NOTIFICATION_TOKEN = "token"
let k_NOTIFICATION_TITLE = "title"
let k_NOTIFICATION_BODY = "body"
let k_NOTIFICATION_ACTION = "action"
let k_NOTIFICATION_OBJECT = "object"
let k_NOTIFICATION_DATE = "date"
let k_NOTIFICATION_READ = "read"

class RemoteNotification: NSObject
{
    private var _id: String?
    var messageTitle: String = ""
    var messageBody: String = ""
    var date: Date = Date()
    var actionType: ActionType = .none
    var objectActionId: String?
    var readStatus: Bool = true
    
    var ID:String
    {
        return self._id ?? ""
    }
    
    init(withId id:String, title:String, body:String, date:String, action:String, objectId:String, read:Bool)
    {
        self._id = id
        self.messageTitle = title
        self.messageBody = body
        self.date = date.getDate() ?? Date()
        self.actionType = ActionType(rawValue: action) ?? .none
        self.objectActionId = objectId
        self.readStatus = read
    }
    
    class func initWith(key:String, dictionary:NSDictionary) -> RemoteNotification
    {
        return RemoteNotification(withId: key,
                                  title: dictionary[k_NOTIFICATION_TITLE] as? String ?? "",
                                  body: dictionary[k_NOTIFICATION_BODY] as? String ?? "",
                                  date: dictionary[k_NOTIFICATION_DATE] as? String ?? "",
                                  action: dictionary[k_NOTIFICATION_ACTION] as? String ?? ActionType.none.rawValue,
                                  objectId: dictionary[k_NOTIFICATION_OBJECT] as? String ?? "",
                                  read: dictionary[k_NOTIFICATION_READ] as? Bool ?? true)
    }
    
}
