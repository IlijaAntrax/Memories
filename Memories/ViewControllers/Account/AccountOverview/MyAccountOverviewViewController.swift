//
//  MyAccountOverview.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/20/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

class MyAccountOverviewViewController:AccountOverviewViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userAccount = MyAccount.sharedInstance.myUser
    }
}
