//
//  AccountViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountOverviewViewController: UIViewController {
    
    var userAccount: User?
    
    @IBOutlet weak var myProfileHeaderView: MyProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        myProfileHeaderView.setup(withDelegate: self, andUser: self.userAccount)
    }

}
