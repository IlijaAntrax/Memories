//
//  FriendAccountOverviewViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/20/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit
import Foundation

class FriendAccountOverviewViewController:AccountOverviewViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var sharedAlbumsLbl: UILabel!
    @IBOutlet var sharedAlbumsCollection: UICollectionView!
    
    private var sharedAlbums:[PhotoAlbum] = [PhotoAlbum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myProfileHeaderView.signOutBtn.isHidden = true
        self.myProfileHeaderView.uploadImgBtn.isHidden = true
        
        self.firstnameTxtField.isUserInteractionEnabled = false
        self.lastnameTxtField.isUserInteractionEnabled = false
        self.emailTxtField.isUserInteractionEnabled = false
        
        self.sharedAlbumsLbl.font = Settings.sharedInstance.fontRegularSizeMedium()
        self.sharedAlbumsLbl.textColor = Settings.sharedInstance.grayNormalColor()
        self.sharedAlbumsLbl.text = "Shared albums with me:"
        
        self.sharedAlbumsCollection.delegate = self
        self.sharedAlbumsCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserController.getUser(forID: self.userAccount!.ID) { (user) in
            self.userAccount = user
            self.setupUserInfo()
        }
        
        PhotoAlbumController.getSharedАlbumsWith(user: MyAccount.sharedInstance.myUser!, forUserId: self.userAccount!.ID) { (albums) in
            self.sharedAlbums = albums
            self.sharedAlbumsCollection.reloadData()
        }
    }
    
    //MARK: CollectionView delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return sharedAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let sharedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedAlbumCell", for: indexPath) as? SharedAlbumCell
        
        sharedCell?.album = self.sharedAlbums[indexPath.item]
        
        return sharedCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let albumVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as? AlbumViewController {
            albumVC.photoAlbum = self.sharedAlbums[indexPath.row]
            self.navigationController?.pushViewController(albumVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height = collectionView.frame.size.height
        let width = height * 400 / 500
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let insset:CGFloat = 0.0
        
        return UIEdgeInsets.init(top: 0.0, left: insset, bottom: 0.0, right: insset)
    }
}
