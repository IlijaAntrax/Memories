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
    //READ
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
    
    //WRITE
    static func addMyAccount(user:User) -> User
    {
        let userQuery = dbRef.child(k_db_users).childByAutoId()
        
        let userDictionary = NSMutableDictionary()
        userDictionary.setValue(user.username, forKey: k_USER_USERNAME)
        userDictionary.setValue(user.email, forKey: k_USER_EMAIL)
//        userDictionary.setValue(user.firstname, forKey: k_USER_FIRSTNAME)
//        userDictionary.setValue(user.lastname, forKey: k_USER_LASTNAME)
//        userDictionary.setValue(user.profileImgUrl?.absoluteString, forKey: k_USER_IMGURL)
        
        userQuery.setValue(userDictionary)
        
        return User(withID: userQuery.key, username: user.username, email: user.email, firstname: "", lastname: "", imgUrl: "")
    }
    
    static func addUserOnAlbum(user:User, album:PhotoAlbum)
    {
        let userQuery = dbRef.child(k_db_users).child(user.ID).child(k_USER_SHARED).childByAutoId()
        userQuery.setValue(album.ID)
        
        let albumQuery = dbRef.child(k_db_albums).child(album.ID).child(k_PHOTOALBUM_USERS).child(user.ID)
        let userDictionary = NSMutableDictionary()
        userDictionary.setValue(user.username, forKey: k_USER_USERNAME)
        userDictionary.setValue(user.email, forKey: k_USER_EMAIL)
        albumQuery.setValue(userDictionary)
    }
    
    static func addUsersOnAlbum(users:[User], album:PhotoAlbum)
    {
        for user in users
        {
            self.addUserOnAlbum(user: user, album: album)
        }
    }
    
    //UPDATE
    static func updateMyAccount(user:User)
    {
        let userQuery = dbRef.child(k_db_users).child(user.ID)
        
        let userDictionary = NSMutableDictionary()
        userDictionary.setValue(user.username, forKey: k_USER_USERNAME)
        userDictionary.setValue(user.email, forKey: k_USER_EMAIL)
        userDictionary.setValue(user.firstname, forKey: k_USER_FIRSTNAME)
        userDictionary.setValue(user.lastname, forKey: k_USER_LASTNAME)
        userDictionary.setValue(user.profileImgUrl?.absoluteString, forKey: k_USER_IMGURL)
        
        userQuery.setValue(userDictionary)
    }
}
