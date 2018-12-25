//
//  State.swift
//  Memories
//
//  Created by Ilija Antonijevic on 25/12/2018.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

protocol State
{
    func isLoggedIn(account: MyAccount) -> Bool
    func userId(account: MyAccount) -> String?
    func email(account: MyAccount) -> String?
}

class LoggedOutState: State
{
    func isLoggedIn(account: MyAccount) -> Bool
    {
        return false
    }
    
    func userId(account: MyAccount) -> String?
    {
        return nil
    }
    
    func email(account: MyAccount) -> String?
    {
        return nil
    }
}

class LoggedInState: State
{
    let user: User
    
    init(user: User)
    {
        self.user = user
    }
    
    func isLoggedIn(account: MyAccount) -> Bool
    {
        return true
    }
    
    func userId(account: MyAccount) -> String?
    {
        return self.user.ID
    }
    
    func email(account: MyAccount) -> String?
    {
        return self.user.email
    }
}
