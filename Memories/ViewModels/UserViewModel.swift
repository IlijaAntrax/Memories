//
//  UserViewModel.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

class UserViewModel:ViewModelDelegate
{
    private let user:User
    
    init(user: User) {
        self.user = user
    }
    
    func configure(_ cell: UICollectionViewCell) {
        if let cell = cell as? UserCell {
            //set image
            if let profileImg = user.profileImg
            {
                cell.profileImgView.image = profileImg
            }
            else
            {
                PhotoController.downloadProfilePhoto(forUserID: user.ID) { (image) in
                    if let img = image
                    {
                        cell.profileImgView.image = img
                        self.user.profileImg = img
                    }
                    else
                    {
                        cell.profileImgView.image = UIImage(named: "profie_icon.png")
                    }
                }
            }
            //set text
            cell.usernameLbl.text = user.username
        }
    }
    
    func saveData() {
        //No implementation
    }
    
    func loadData() {
        //No implementation
    }
    
}
