//
//  RemoteNotification.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

let k_NOTIFICATION_TITLE = "title"
let k_NOTIFICATION_BODY = "body"
let k_NOTIFICATION_ACTION = "action"
let k_NOTIFICATION_OBJECT = "object"

class RemoteNotification: NSObject
{
    private var _id: String?
    var messageTitle: String = ""
    var messageBody: String = ""
    var actionType: ActionType = .none
    var objectActionId: String?
    
    init(withId id:String, title:String, body:String, action:String, objectId:String)
    {
        self._id = id
        self.messageTitle = title
        self.messageBody = body
        self.actionType = ActionType(rawValue: action) ?? .none
        self.objectActionId = objectId
    }
    
    class func initWith(key:String, dictionary:NSDictionary) -> RemoteNotification
    {
        return RemoteNotification(withId: key,
                                  title: dictionary[k_NOTIFICATION_TITLE] as? String ?? "",
                                  body: dictionary[k_NOTIFICATION_BODY] as? String ?? "",
                                  action: dictionary[k_NOTIFICATION_ACTION] as? String ?? ActionType.none.rawValue,
                                  objectId: dictionary[k_NOTIFICATION_OBJECT] as? String ?? "")
    }
    
}
