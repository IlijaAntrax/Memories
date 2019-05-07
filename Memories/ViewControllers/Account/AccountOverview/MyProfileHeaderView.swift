//
//  MyProfileHeaderView.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/20/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class MyProfileHeaderView:UIView
{
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var bgdImgView: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var friendsLbl: UILabel!
    @IBOutlet weak var friendsCntLbl: UILabel!
    
    @IBOutlet weak var myAlbumsLbl: UILabel!
    @IBOutlet weak var myAlbumsCntLbl: UILabel!
    
    @IBOutlet weak var sharedLbl: UILabel!
    @IBOutlet weak var sharedCntLbl: UILabel!
    
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    
    weak var controllerDelegate:UIViewController?
    
    var user: User?
    
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
    
    func setup(withDelegate delegate:UIViewController?, andUser user:User?)
    {
        self.controllerDelegate = delegate
        self.user = user
        self.setup()
    }
    
    func setup(withDelegate delegate:UIViewController?)
    {
        self.controllerDelegate = delegate
        self.setup()
    }
    
    func setup(withUser user:User?)
    {
        self.user = user
        self.setup()
    }
    
    private func setup()
    {
        self.usernameLbl.text = "\((user?.username ?? ""))"
        
        if let profileImg = user?.profileImg
        {
            addMask(forView: self.profileImgView)
            self.profileImgView.image = profileImg
        }
        else
        {
            PhotoController.downloadProfilePhoto(forUserID: user?.ID ?? "") { (image) in
                self.addMask(forView: self.profileImgView)
                if let img = image
                {
                    self.user?.profileImg = img
                    self.profileImgView.image = img
                }
                else
                {
                    self.profileImgView.image = UIImage(named: "profie_icon.png")
                }
            }
        }
        
        PhotoAlbumController.getAlbumsCount(forUserEmail: user?.email ?? "") { (cnt) in
            self.myAlbumsCntLbl.text = "\(cnt)"
        }
        
        PhotoAlbumController.getSharedAlbumsCount(forUserId: user?.ID ?? "") { (cnt) in
            self.sharedCntLbl.text = "\(cnt)"
        }
        
        UserController.getFriendsCount(forUserId: user?.ID ?? "") { (cnt) in
            self.friendsCntLbl.text = "\(cnt)"
        }
    }
    
    @IBAction func uploadProfileIm(_ sender: Any)
    {
        if self.controllerDelegate != nil
        {
            ImagePickerManager().pickImage(self.controllerDelegate!) { (profileImage) in
                self.user?.profileImg = profileImage
                self.addMask(forView: self.profileImgView)
                self.profileImgView.image = profileImage
                PhotoController.uploadProfileImage(image: profileImage, forUserID: MyAccount.sharedInstance.userId ?? "", completionHandler: { (success) in
                    print(success)
                    if let imgUrl = MyAccount.sharedInstance.myUser?.profileImgUrl {
                        PhotoController.deleteImage(withUrlPath: imgUrl.absoluteString, completionHandler: { (succes) in
                            print(success)
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any)
    {
        let alert = UIAlertController(title: "Sign out", message: "Are you sure that you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Sign out", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            do {
                try Auth.auth().signOut()
                MyAccount.sharedInstance.logOut()
                self.controllerDelegate?.navigationController?.dismiss(animated: true, completion: nil)
            } catch { print(error) } //TODO: show error alert
        }))
        
        self.controllerDelegate?.present(alert, animated: true, completion: nil)
    }
}
