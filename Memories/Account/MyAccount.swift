//
//  MyAccount.swift
//  Memories
//
//  Created by Ilija Antonjevic on 25/12/2018.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

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
    
    func logIn(user: User)
    {
        self.state = LoggedInState(user: user)
    }
    
    func logOut()
    {
        self.state = LoggedOutState()
    }
}
