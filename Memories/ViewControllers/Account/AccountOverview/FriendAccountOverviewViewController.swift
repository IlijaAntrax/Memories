//
//  FriendAccountOverviewViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/20/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

class FriendAccountOverviewViewController:AccountOverviewViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myProfileHeaderView.signOutBtn.isHidden = true
        self.myProfileHeaderView.uploadImgBtn.isHidden = true
    }
}
