//
//  UserCell.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

class UserCell:UICollectionViewCell
{
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        usernameLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        usernameLbl.textColor = Settings.sharedInstance.grayNormalColor()
    }
    
    var user:User?
    {
        didSet
        {
            if let user = user
            {
                profileImgView.image = user.profileImg ?? UIImage(named: "profie_icon.png")
                usernameLbl.text = user.username
            }
        }
    }
}
