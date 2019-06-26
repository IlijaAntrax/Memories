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
        
        self.profileImgView.contentMode = UIViewContentMode.scaleAspectFill
        self.profileImgView.image = UIImage(named: "profie_icon.png")
        profileImgView.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let key = keyPath
        {
            if key == "bounds"
            {
                if let imgView = object as? UIImageView
                {
                    if imgView == self.profileImgView
                    {
                        addMask(forView: profileImgView)
                    }
                }
            }
        }
    }
    
    func addMask(forView maskView:UIView)
    {
        if maskView.layer.mask == nil
        {
            let maskImg = UIImage(named: "profile_image_mask")!
            let mask = CALayer()
            mask.contents = maskImg.cgImage
            mask.frame = CGRect.init(x: 0.0, y: 0.0, width: maskView.frame.width, height: maskView.frame.height)
            maskView.layer.mask = mask
            maskView.layer.masksToBounds = true
        }
        else
        {
            maskView.layer.mask?.frame = CGRect.init(x: 0.0, y: 0.0, width: maskView.frame.width, height: maskView.frame.height)
        }
    }
}
