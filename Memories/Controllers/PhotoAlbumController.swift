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
}
