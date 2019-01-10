//
//  ViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 11/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (MyAccount.sharedInstance.isLoggedIn == false) //Load from local settings
        {
            performSegue(withIdentifier: "LoginSegueIdentifier", sender: self.view)
        }
        else
        {
            performSegue(withIdentifier: "HomeSegueIdentifier", sender: self)
        }
    }

}

