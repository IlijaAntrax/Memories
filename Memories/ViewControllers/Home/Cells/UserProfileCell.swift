//
//  UserProfileCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var bgdImgView: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var friendsLbl: UILabel!
    @IBOutlet weak var friendsCntLbl: UILabel!
    
    @IBOutlet weak var myAlbumsLbl: UILabel!
    @IBOutlet weak var myAlbumsCntLbl: UILabel!
    
    @IBOutlet weak var sharedLbl: UILabel!
    @IBOutlet weak var sharedCntLbl: UILabel!
    
    var myAlbumsCnt:Int?
    var sharedAlbumsCnt:Int?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        bgdImgView.contentMode = .scaleAspectFill
        bgdImgView.image = UIImage(named: "profile_default_cover.jpg")
        bgdImgView.alpha = 0.175
        
        usernameLbl.font = Settings.sharedInstance.fontBoldSizeLarge()
        usernameLbl.textColor = Settings.sharedInstance.grayDarkColor()
        
        friendsLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        friendsLbl.textColor = Settings.sharedInstance.grayNormalColor()
        friendsCntLbl.font = Settings.sharedInstance.fontBoldSizeSmall()
        friendsCntLbl.textColor = Settings.sharedInstance.primaryColor()
        
        myAlbumsLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        myAlbumsLbl.textColor = Settings.sharedInstance.grayNormalColor()
        myAlbumsCntLbl.font = Settings.sharedInstance.fontBoldSizeSmall()
        myAlbumsCntLbl.textColor = Settings.sharedInstance.primaryColor()
        
        sharedLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        sharedLbl.textColor = Settings.sharedInstance.grayNormalColor()
        sharedCntLbl.font = Settings.sharedInstance.fontBoldSizeSmall()
        sharedCntLbl.textColor = Settings.sharedInstance.primaryColor()
    }
    
    func setup()
    {
        self.usernameLbl.text = "\((MyAccount.sharedInstance.username ?? ""))"
        
        if let count = myAlbumsCnt
        {
            self.myAlbumsCntLbl.text = "\(count)"
        }
        else
        {
            PhotoAlbumController.getAlbumsCount(forUserEmail: MyAccount.sharedInstance.email ?? "") { (cnt) in
                self.myAlbumsCnt = cnt
                self.myAlbumsCntLbl.text = "\(cnt)"
            }
        }
        
        if let count = sharedAlbumsCnt
        {
            self.sharedCntLbl.text = "\(count)"
        }
        else
        {
            PhotoAlbumController.getSharedAlbumsCount(forUserId: MyAccount.sharedInstance.userId ?? "") { (cnt) in
                self.sharedAlbumsCnt = cnt
                self.sharedCntLbl.text = "\(cnt)"
            }
        }
    }
}
