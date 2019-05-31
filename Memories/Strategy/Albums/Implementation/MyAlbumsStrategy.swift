//
//  MyAlbumsStrategy.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

class MyAlbumsStrategy: AlbumsStrategy
{
    func loadAlbums(completionHandler: @escaping ([PhotoAlbum]) -> ()) {
        if let email = MyAccount.sharedInstance.email {
            PhotoAlbumController.getAlbums(forUserEmail: email) { (albums) in
                completionHandler(albums)
            }
        } else {
            completionHandler([PhotoAlbum]())
        }
    }
    
    func isAlbumDataUpdated(_ album:AlbumViewModel, updatedAlbum:AlbumViewModel) -> Bool {
        //Check if photos count changed.
        if album.photoAlbum.photos.count != updatedAlbum.photoAlbum.photos.count {
            return true
        }
        
        //Check if some photos are deleted and some added(count still same)
        for photo in album.photoAlbum.photos {
            if !updatedAlbum.photoAlbum.photos.contains(where: { (updatedPhoto) -> Bool in
                if photo.ID == updatedPhoto.ID {
                    return true
                }
                return false
            }) {
                return true
            }
        }
        
        //Check if users changed on album
        if album.albumUsers.count != updatedAlbum.albumUsers.count {
            return true
        }
        
        for user in album.albumUsers {
            if updatedAlbum.albumUsers.contains(where: { (updatedUser) -> Bool in
                if user.ID == updatedUser.ID {
                    return true
                }
                return false
            }) {
                return true
            }
        }
        
        return false
    }
}
