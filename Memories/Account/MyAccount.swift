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
            if let id = state.userId(account: self) {
                return id
            } else {
                return KeychainService.loadPassword(service: kSecService, account: kSecAccount)
            }
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
    
    private var _token:String?
    var token: String?
    {
        get
        {
            return self._token
        }
        set
        {
            self._token = newValue
        }
    }
    
    func setProfileImage(image:UIImage)
    {
        state.myUser(account: self)?.profileImg = image
    }
    
    func logIn(user: User)
    {
        if let token = self._token {
            RemoteNotificationController.setToken(token: token, forUser: user)
        }
        if let _ = KeychainService.loadPassword(service: kSecService, account: kSecAccount) {
            KeychainService.updatePassword(service: kSecService, account: kSecAccount, data: user.ID)
        } else {
            KeychainService.savePassword(service: kSecService, account: kSecAccount, data: user.ID)
        }
        self.state = LoggedInState(user: user)
    }
    
    func logOut()
    {
        self.token = nil
        KeychainService.removePassword(service: kSecService, account: kSecAccount)
        self.state = LoggedOutState()
    }
}
