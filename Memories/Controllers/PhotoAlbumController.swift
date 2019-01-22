//
//  PhotoAlbumController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

class PhotoAlbumController:FirebaseController
{
    //READ
    static func getAlbumsCount(forUserId userId:String, completionHandler:@escaping (Int) -> ())
    {
        let albumsQuery = dbRef.child(k_db_albums).queryOrdered(byChild: k_PHOTOALBUM_OWNER).queryEqual(toValue: userId)
        albumsQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsArray = dataSnapshot.value as? NSDictionary
            {
                completionHandler(albumsArray.count)
            }
            else
            {
                completionHandler(0)
            }
        }
    }
    
    static func getAlbumsCount(forUserEmail email:String, completionHandler:@escaping (Int) -> ())
    {
        let albumsQuery = dbRef.child(k_db_albums).queryOrdered(byChild: k_PHOTOALBUM_OWNER).queryEqual(toValue: email)
        albumsQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsArray = dataSnapshot.value as? NSDictionary
            {
                completionHandler(albumsArray.count)
            }
            else
            {
                completionHandler(0)
            }
        }
    }
    
    static func getAlbum(forAlbumId albumId:String, completionHandler:@escaping (PhotoAlbum) -> ())
    {
        let albumQuery = dbRef.child(k_db_albums).child(albumId)
        albumQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumDictionary = dataSnapshot.value as? NSDictionary
            {
                completionHandler(PhotoAlbum.initWith(key: albumId, dictionary: albumDictionary))
            }
        }
    }
    
    static func getAlbums(forUserId userId:String, completionHandler:@escaping ([PhotoAlbum]) -> ())
    {
        let albumsQuery = dbRef.child(k_db_albums).queryOrdered(byChild: k_PHOTOALBUM_OWNER).queryEqual(toValue: userId)
        albumsQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsArray = dataSnapshot.value as? NSDictionary
            {
                var albums = [PhotoAlbum]()
                for albumData in albumsArray.enumerated()
                {
                    albums.append(PhotoAlbum.initWith(key: albumData.element.key as! String, dictionary: albumData.element.value as! NSDictionary))
                }
                completionHandler(albums)
            }
        }
    }
    
    static func getAlbums(forUserEmail email:String, completionHandler:@escaping ([PhotoAlbum]) -> ())
    {
        let albumsQuery = dbRef.child(k_db_albums).queryOrdered(byChild: k_PHOTOALBUM_OWNER).queryEqual(toValue: email)
        albumsQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsArray = dataSnapshot.value as? NSDictionary
            {
                var albums = [PhotoAlbum]()
                for albumData in albumsArray.enumerated()
                {
                    albums.append(PhotoAlbum.initWith(key: albumData.element.key as! String, dictionary: albumData.element.value as! NSDictionary))
                }
                completionHandler(albums)
            }
        }
    }
    
    static func getSharedAlbumsCount(forUserId userId:String, completionHandler:@escaping (Int) -> ())
    {
        let sharedQuery = dbRef.child(k_db_users).child(userId).child(k_USER_SHARED)
        sharedQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsKeys = dataSnapshot.value as? [String]
            {
                completionHandler(albumsKeys.count)
            }
            else if let albumsDict = dataSnapshot.value as? NSDictionary
            {
                completionHandler(albumsDict.allKeys.count)
            }
            else
            {
                completionHandler(0)
            }
        }
    }
    
    static func getSharedAlbums(forUserId userId:String, completionHandler:@escaping ([PhotoAlbum]) -> ())
    {
        let sharedQuery = dbRef.child(k_db_users).child(userId).child(k_USER_SHARED)
        sharedQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let albumsKeys = dataSnapshot.value as? [String]
            {
                var albumsCount = albumsKeys.count
                var albums = [PhotoAlbum]()
                
                for key in albumsKeys
                {
                    self.getAlbum(forAlbumId: key, completionHandler: { (album) in
                        albumsCount -= 1
                        albums.append(album)
                        if albumsCount == 0
                        {
                            completionHandler(albums)
                        }
                    })
                }
            }
            else if let albumKeys = dataSnapshot.value as? NSDictionary
            {
                var albumsCount = albumKeys.allKeys.count
                var albums = [PhotoAlbum]()
                
                for key in albumKeys.allKeys
                {
                    self.getAlbum(forAlbumId: albumKeys[key] as! String, completionHandler: { (album) in
                        albumsCount -= 1
                        albums.append(album)
                        if albumsCount == 0
                        {
                            completionHandler(albums)
                        }
                    })
                }
            }
        }
    }
    
    static func getSharedAlbums(forUserEmail email:String, completionHandler:@escaping ([PhotoAlbum]) -> ())
    {
        let sharedQuery = dbRef.child(k_db_users).queryOrdered(byChild: k_USER_EMAIL).queryEqual(toValue: email)
        sharedQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let userData = dataSnapshot.value as? NSDictionary
            {
                if let userKey = userData.allKeys.first
                {
                    if let albumDictionary = userData[userKey] as? NSDictionary
                    {
                        if let albumsKeys = albumDictionary[k_USER_SHARED] as? [String]
                        {
                            var albumsCount = albumsKeys.count
                            var albums = [PhotoAlbum]()
                            
                            for key in albumsKeys
                            {
                                self.getAlbum(forAlbumId: key, completionHandler: { (album) in
                                    albumsCount -= 1
                                    albums.append(album)
                                    if albumsCount == 0
                                    {
                                        completionHandler(albums)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    //WRITE
    static func addPhotoAlbum(album:PhotoAlbum)
    {
        let albumQuery = dbRef.child(k_db_albums).childByAutoId()
        
        let albumDictionary = NSMutableDictionary()
        albumDictionary.setValue(album.name, forKey: k_PHOTOALBUM_NAME)
        albumDictionary.setValue(album.creationDate.getString(), forKey: k_PHOTOALBUM_DATE)
        albumDictionary.setValue(album.owner, forKey: k_PHOTOALBUM_OWNER)
        
        albumQuery.setValue(albumDictionary)
    }
    
    static func addPhotoAlbum(album:PhotoAlbum, withPhotos photos:[Photo], withUsers users:[User])
    {
        let albumQuery = dbRef.child(k_db_albums).childByAutoId()
        let albumKey = albumQuery.key
        
        let albumDictionary = NSMutableDictionary()
        albumDictionary.setValue(album.name, forKey: k_PHOTOALBUM_NAME)
        albumDictionary.setValue(album.creationDate.getString(), forKey: k_PHOTOALBUM_DATE)
        albumDictionary.setValue(album.owner, forKey: k_PHOTOALBUM_OWNER)
        
        albumQuery.setValue(albumDictionary)
        
        PhotoController.addPhotosToAlbum(photos: photos, album: PhotoAlbum.initWith(key: albumKey, dictionary: albumDictionary))
        UserController.addUsersOnAlbum(users: users, album: PhotoAlbum.initWith(key: albumKey, dictionary: albumDictionary))
    }
    
    //DELETE
    static func deletePhotoAlbum(_ photoAlbum: PhotoAlbum)
    {
        let albumID = photoAlbum.ID
        
        UserController.getUsersOnAlbum(forAlbumId: albumID) { (users) in
            for user in users
            {
                let userAlbumQuery = dbRef.child(k_db_users).child(user.ID).child(k_USER_SHARED).queryEqual(toValue: user.ID).ref
                userAlbumQuery.observeSingleEvent(of: .value, with: { (data) in
                    if let albums = data.value as? [String]
                    {
                        for sharedAlbumId in albums
                        {
                            if (sharedAlbumId == albumID)
                            {
                                let sharedAlbumQuery = dbRef.child(k_db_users).child(user.ID).child(k_USER_SHARED).child(sharedAlbumId)
                                sharedAlbumQuery.removeValue()
                            }
                        }
                    }
                })
            }
            
            let albumQuery = dbRef.child(k_db_albums).child(albumID)
            albumQuery.removeValue()
        }
    }
}
