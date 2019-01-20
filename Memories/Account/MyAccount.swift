//
//  MyAccount.swift
//  Memories
//
//  Created by Ilija Antonjevic on 25/12/2018.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

final class MyAccount
{
    static let sharedInstance: MyAccount = {
        let instance = MyAccount()
        // setup code
        return instance
    }()
    
    private var state: State = LoggedOutState()
    
    var isLoggedIn: Bool
    {
        get
        {
            return state.isLoggedIn(account: self)
        }
    }
    
    var userId: String?
    {
        get
        {
            return state.userId(account: self)
        }
    }
    
    var email: String?
    {
        get
        {
            return state.email(account: self)
        }
    }
    
    var myUser: User?
    {
        get
        {
            return state.myUser(account: self)
        }
    }
    
    func setProfileImage(image:UIImage)
    {
        state.myUser(account: self)?.profileImg = image
    }
    
    func logIn(user: User)
    {
        self.state = LoggedInState(user: user)
    }
    
    func logOut()
    {
        self.state = LoggedOutState()
    }
}
