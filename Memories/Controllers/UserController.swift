//
//  UserController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserController:FirebaseController
{
    static func getUser(forEmail email:String, completionHandler:@escaping (User) -> ())
    {
        let userQuery = dbRef.child(k_db_users).queryOrdered(byChild: k_USER_EMAIL).queryEqual(toValue: email)
        userQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let queryDictionary = dataSnapshot.value as? NSDictionary
            {
                if let key = queryDictionary.allKeys.first as? String
                {
                    if let dictionary = queryDictionary[key] as? NSDictionary
                    {
                        completionHandler(User.initWith(key: key, dictionary: dictionary))
                    }
                }
            }
        }
    }
    
    static func getUser(forID id:String, completionHandler:@escaping (User) -> ())
    {
        let userQuery = dbRef.child(k_db_users).child(id)
        userQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let dictionary = dataSnapshot.value as? NSDictionary
            {
                completionHandler(User.initWith(key: id, dictionary: dictionary))
            }
        }
    }
    
    static func getUsersOnAlbum(forAlbumId albumId:String, completionHandler:@escaping ([User]) -> ())
    {
        let usersQuery = dbRef.child(k_db_albums).child(albumId).child(k_PHOTOALBUM_USERS)
        usersQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let usersDictionaries = dataSnapshot.value as? NSDictionary
            {
                var users = [User]()
                for userDict in usersDictionaries.enumerated()
                {
                    users.append(User.initWith(key: userDict.element.key as! String, dictionary: userDict.element.value as! NSDictionary))
                }
                completionHandler(users)
            }
        }
    }
}
