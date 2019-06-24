//
//  ViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 11/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.statusBarView?.backgroundColor = Settings.sharedInstance.primaryColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MyAccount.sharedInstance.isLoggedIn == false {
            if let myUser = Auth.auth().currentUser
            {
                UserController.getUser(forEmail: myUser.email ?? "", completionHandler: { (myUser) in
                    MyAccount.sharedInstance.logIn(user: myUser)
                    self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: self)
                })
            }
            else
            {
                performSegue(withIdentifier: "LoginSegueIdentifier", sender: self.view)
            }
        } else {
            self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: self)
        }
    }

}

