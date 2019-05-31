//
//  AlbumViewModel.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

class AlbumViewModel
{
    private var album:PhotoAlbum
    private var users:[User]
    
    init(album: PhotoAlbum) {
        self.album = album
        self.users = [User]()
    }
    
    var photoAlbum: PhotoAlbum {
        return self.album
    }
    
    var albumImage: UIImage?
    
    var albumUsers:[User] {
        get {
            return self.users
        }
        set {
            self.users = newValue
        }
    }
    
    func configure(_ cell: AlbumCell) {
        
        cell.addLoaderMask()
        cell.loaderView.startAnimating()
        
        cell.albumImgView.image = albumImage
        
        if cell.albumImgView.image == nil
        {
            if let firstPhoto = album.photos.first
            {
                if let image = firstPhoto.img
                {
                    cell.albumImgView.image = image
                    self.albumImage = image
                }
                else if let url = firstPhoto.imgUrl
                {
                    PhotoController.downloadImage(fromUrl: url) { (image) in
                        let img = FilterStore.filterImage(image: image, filterType: firstPhoto.filter, intensity: 0.5)
                        
                        cell.albumImgView.image = img
                        self.albumImage = img
                        
                        cell.loaderView.stopAnimating()
                    }
                }
            }
            else
            {
                //TODO: set img holder for album image
                cell.albumImgView.image = Settings.sharedInstance.emptyAlbumImage()
                cell.loaderView.stopAnimating()
            }
        }
        else
        {
            cell.loaderView.stopAnimating()
        }
        
        cell.albumNameLbl.text = album.name
        cell.photosCountLbl.text = String(album.photos.count) + " photos"
        
        cell.addMask()
    }
    
    func configureForUsers(_ cell: MyAlbumCell) {
        UserController.getUsersOnAlbum(forAlbumId: album.ID) { (users) in
            self.albumUsers = users
            cell.peopleCountLbl.text = "shared with \(users.count) people" //TODO: add album users on album and setup cells
            cell.usersList = users
            cell.albumUsersCollection.reloadData()
        }
    }
}
