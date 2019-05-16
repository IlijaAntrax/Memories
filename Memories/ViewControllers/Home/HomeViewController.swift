//
//  HomeViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/10/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserProfileDelegate {

    var selectedAlbumID:String!
    var albums:[PhotoAlbum] = [PhotoAlbum]()
    
    @IBOutlet weak var albumsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.albumsCollection.delegate = self
        self.albumsCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadAlbum { (photoAlbums) in
            self.albums = photoAlbums
            self.albumsCollection.reloadData()
        }
    }
    

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MyAlbumSegueIdentifier" || segue.identifier == "SharedAlbumSegueIdentifier"
        {
            if let albumVC = segue.destination as? AlbumViewController
            {
                albumVC.photoAlbumID = self.selectedAlbumID
                if let index = self.albums.firstIndex(where: { (photoAlbum) -> Bool in
                    if photoAlbum.ID == self.selectedAlbumID {
                        return true
                    }
                    return false
                }) {
                    albumVC.photoAlbum = self.albums[index]
                }
            }
        }
    }

    func showAlbumVC(forIndex index:Int)
    {
        self.selectedAlbumID = self.albums[index].ID
        
        if self is MyAlbumsViewController {
            performSegue(withIdentifier: "MyAlbumSegueIdentifier", sender: self)
        } else if self is SharedAlbumsViewController {
            performSegue(withIdentifier: "SharedAlbumSegueIdentifier", sender: self)
        }
    }
    
    func loadAlbum(completionHandler:@escaping ([PhotoAlbum]) -> ())
    {
        completionHandler(self.albums)
    }
    
    //MARK: Add new album control
    func addNewAlbum()
    {
        let alert = UIAlertController(title: "New Album", message: "Enter a name for new album", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            if let tField = alert.textFields?.first
            {
                if let albumName = tField.text
                {
                    self.createNewAlbum(withName: albumName)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createNewAlbum(withName albumName: String)
    {
        let album = PhotoAlbum(withID: "", name: albumName, date: Date(), owner: MyAccount.sharedInstance.email ?? "", photos: [Photo]())
        
        PhotoAlbumController.addPhotoAlbum(album: album)
        
        self.loadAlbum { (photoAlbums) in
            self.albums = photoAlbums
            self.albumsCollection.reloadData()
        }
    }
    
    //MARK: User Profile Delegate
    func userSelected(_ user: User)
    {
        if let userVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendAccountOverviewViewController") as? FriendAccountOverviewViewController {
            userVC.userAccount = user
            self.navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
    func addNewUserOnAlbum(_ album: PhotoAlbum)
    {
        if let usersVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchAccountViewController") as? SearchAccountViewController {
            usersVC.albumToShare = album
            self.navigationController?.pushViewController(usersVC, animated: true)
        }
    }
    
    //MARK: CollectionView delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.albums.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.item == 0 // profile cell
        {
            let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell
            
            profileCell?.myProfileHeaderView.setup(withUser: MyAccount.sharedInstance.myUser)
            
            return profileCell!
        }
        else if indexPath.item == 1
        {
            //TODO: show add new album cell
            let newAlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewAlbumCell", for: indexPath) as? NewAlbumCell
            
            newAlbumCell?.setupDefault()
            
            return newAlbumCell!
        }
        else
        {
            //TODO: show albums
            let myAlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAlbumCell", for: indexPath) as? MyAlbumCell
            
            myAlbumCell?.album = self.albums[indexPath.item - 2]
            myAlbumCell?.userDelegate = self
            
            return myAlbumCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.item == 0
        {
            self.tabBarController?.selectedIndex = 2
        }
        else if indexPath.item == 1
        {
            self.addNewAlbum()
        }
        else
        {
            showAlbumVC(forIndex: indexPath.row - 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.item == 0
        {
            let width = collectionView.frame.width
            let height = width * 420 / 1242
            
            return CGSize(width: width, height: height)
        }
        else if indexPath.item == 1
        {
            let width = collectionView.frame.width
            let height = width * 270 / 1242
            
            return CGSize(width: width, height: height)
        }
        else
        {
            let width = collectionView.frame.width
            let height = width * 445 / 1242
            
            return CGSize(width: width, height: height)
        }
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
