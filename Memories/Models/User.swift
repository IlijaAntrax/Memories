//
//  User.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

let k_USER_USERNAME = "name"
let k_USER_EMAIL = "email"
let k_USER_FIRSTNAME = "firstname"
let k_USER_LASTNAME = "lastname"
let k_USER_IMGURL = "profileUrl"

class User: NSObject
{
    private var _id:String?
    var username:String = ""
    var email:String = ""
    var firstname:String?
    var lastname:String?
    var profileImgUrl:URL?
    var profileImg:UIImage?
    
    init(withID id:String, username:String, email:String, firstname:String, lastname:String, imgUrl:String)
    {
        self._id = id
        self.username = username
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.profileImgUrl = URL(fileURLWithPath: imgUrl)
    }
    
    class func initWith(key:String, dictionary:NSDictionary) -> User
    {
        return User(withID: key,
                    username: dictionary[k_USER_USERNAME] as? String ?? "",
                    email: dictionary[k_USER_EMAIL] as? String ?? "",
                    firstname: dictionary[k_USER_FIRSTNAME] as? String ?? "",
                    lastname: dictionary[k_USER_LASTNAME] as? String ?? "",
                    imgUrl: dictionary[k_USER_IMGURL] as? String ?? "")
    }
}
