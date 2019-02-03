//
//  AlbumViewController.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private let cellsInRow:Int = 3
    private let insetOffset:CGFloat = 5.0
    
    var isSharedAlbum = false
    var photoAlbum: PhotoAlbum?
    var albumUsers = [User]()
    
    var selectedPhoto: Photo?
    
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var inviteUserBtn: UIButton!
    
    @IBOutlet weak var usersCollection: UICollectionView!
    @IBOutlet weak var photosCollection: UICollectionView!
    
    var deleteBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        photosCollection.delegate = self
        photosCollection.dataSource = self
        
        usersCollection.delegate = self
        usersCollection.dataSource = self
        
        self.loadUsersForAlbum()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.photosCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "GallerySegueIdentifier"
        {
            if let galleryVC = segue.destination as? GalleryViewController
            {
                galleryVC.photoAlbum = self.photoAlbum
            }
        }
        else if segue.identifier == "SearchUsersSegueIdentifier"
        {
            if let searchUsersVC = segue.destination as? SearchAccountViewController
            {
                searchUsersVC.albumToShare = self.photoAlbum
            }
        }
        else if segue.identifier == "PhotoSegueIdentifier"
        {
            if let photoEditVC = segue.destination as? PhotoViewController
            {
                photoEditVC.photo = self.selectedPhoto
            }
        }
    }
    
    func setup()
    {
        if self.isSharedAlbum
        {
            self.inviteUserBtn.isHidden = true
        }
    }
    
    func loadUsersForAlbum()
    {
        UserController.getUsersOnAlbum(forAlbumId: photoAlbum?.ID ?? "") { (users) in
            self.albumUsers = users
            if self.isSharedAlbum {
                if let owner = self.photoAlbum?.owner {
                    UserController.getUser(forEmail: owner, completionHandler: { (user) in
                        self.albumUsers.insert(user, at: 0)
                        self.usersCollection.reloadData()
                    })
                } else {
                    self.usersCollection.reloadData()
                }
            } else {
                self.usersCollection.reloadData()
            }
        }
    }
    
    @objc func deletePhotosAction()
    {
        
    }
    
    @objc func showDeleteAlert(_ notification: NSNotification)
    {
        if let photo = notification.object as? Photo
        {
            let deleteAlert = UIAlertController(title: "Delete photo!", message: "Are you sure, you want to delete this photo?", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                //delete photo
                self.deletePhoto(photo: photo)
                deleteAlert.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            deleteAlert.addAction(yesAction)
            deleteAlert.addAction(cancelAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    func deletePhoto(photo: Photo?)
    {
        
    }
    
    @objc func reloadAlbum()
    {
        photosCollection.reloadData()
    }
    
    func addPhotos()
    {
        performSegue(withIdentifier: "GallerySegueIdentifier", sender: self)
    }
    
    @IBAction func inviteUserAction(_ sender: Any)
    {
        if let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchAccountViewController") as? SearchAccountViewController {
            searchVC.albumToShare = self.photoAlbum
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    
    //MARK: Collection view delegate, data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == usersCollection
        {
            return albumUsers.count
        }
        else
        {
            let extraCells = 1
            if let album = photoAlbum
            {
                return album.photos.count + extraCells
            }
            
            return extraCells
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == usersCollection
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
            
            cell.user = albumUsers[indexPath.item]
            cell.usernameLbl.font = Settings.sharedInstance.fontRegularSizeSmall()
            
            return cell
        }
        else
        {
            if indexPath.item == 0
            {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCell", for: indexPath) as! AddPhotosCell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            
            cell.photo = photoAlbum?.photos[indexPath.row - 1]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == usersCollection
        {
            print("User selected")
            //TODO: show profile, feature, delete user from album on handle press long?
        }
        else
        {
            if indexPath.item == 0
            {
                addPhotos()
            }
            else
            {
                self.selectedPhoto = photoAlbum?.photos[indexPath.item - 1]
                
                performSegue(withIdentifier: "PhotoSegueIdentifier", sender: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == usersCollection
        {
            let width = collectionView.frame.height
            let height = width
            
            return CGSize(width: width, height: height)
        }
        else
        {
            let width = (collectionView.frame.width - (CGFloat(cellsInRow) + 1) * insetOffset) / CGFloat(cellsInRow)
            let height = width
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == usersCollection
        {
            return 0.0
        }
        else
        {
            return insetOffset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == usersCollection
        {
            return 0.0
        }
        else
        {
            return insetOffset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if collectionView == usersCollection
        {
            return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        else
        {
            return UIEdgeInsets.init(top: 0.0, left: insetOffset, bottom: 0.0, right: insetOffset)
        }
    }


}
