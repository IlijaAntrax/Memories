//
//  PhotoAlbum.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/11/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

let k_PHOTOALBUM_NAME = "name"
let k_PHOTOALBUM_OWNER = "owner"
let k_PHOTOALBUM_DATE = "creationDate"
let k_PHOTOALBUM_IMAGES = "images"
let k_PHOTOALBUM_USERS = "users"

class PhotoAlbum: NSObject
{
    private var _id:String?
    var name: String = ""
    var owner: String = ""
    var albumImageUrl: URL?
    var creationDate: Date = Date()
    var photos = [Photo]()
    
    init(withID id:String, name:String, date:Date, owner:String, photos:[Photo])
    {
        self._id = id
        self.name = name
        self.creationDate = date
        self.photos = photos
    }
    
    class func initWith(key:String, dictionary:NSDictionary) -> PhotoAlbum
    {
        return PhotoAlbum(withID: key,
                          name: (dictionary[k_PHOTOALBUM_NAME] as? String) ?? "",
                          date: (dictionary[k_PHOTOALBUM_DATE] as? String)?.getDate() ?? Date(),
                          owner: dictionary[k_PHOTOALBUM_OWNER] as? String ?? "",
                          photos: PhotoController.getPhotos(fromData: dictionary[k_PHOTOALBUM_IMAGES] as? NSDictionary ?? NSDictionary()))
    }

}
