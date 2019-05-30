//
//  MyAlbumCell.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

protocol UserProfileDelegate:class {
    func userSelected(_ user:User)
    func addNewUserOnAlbum(_ album:PhotoAlbum)
}

class MyAlbumCell: AlbumCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var peopleCountLbl:UILabel!
    
    @IBOutlet weak var albumUsersCollection: UICollectionView!
    
    weak var userDelegate:UserProfileDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        peopleCountLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        peopleCountLbl.textColor = Settings.sharedInstance.grayLightColor()
        
        albumUsersCollection.delegate = self
        albumUsersCollection.dataSource = self
    }
    
    var usersList:[User] = [User]() {
        didSet {
            //TODO: set constraints to collectio depends of number of users
        }
    }
    
    override var albumView: AlbumViewModel? {
        didSet {
            albumView?.configure(self)
            albumView?.configureForUsers(self)
        }
    }
    
    @IBAction func addUserBtnPressed(_ sender: Any)
    {
        self.addNew()
    }
    
    override func addNew()
    {
        if let album = self.albumView?.photoAlbum {
            self.userDelegate?.addNewUserOnAlbum(album)
        }
    }
    
    //MARK: Collection view delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return usersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        
        let userView = UserViewModel(user: usersList[indexPath.item])
        userView.configure(cell)
        cell.usernameLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.userDelegate?.userSelected(self.usersList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.frame.height
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
