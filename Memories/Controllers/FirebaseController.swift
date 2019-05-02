//
//  FirebaseController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseController
{
    static let k_db_users = "users"
    static let k_db_albums = "photoalbums"
    static let k_db_notifications = "notifications"
    static let k_db_friendships = "friendships"
    
    static let dbRef = Database.database().reference()
    
    
}
