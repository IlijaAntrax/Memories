//
//  PhotoController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class PhotoController:FirebaseController
{
    //READ
    static func getPhotos(fromData data:NSDictionary) -> [Photo]
    {
        var photos = [Photo]()
        
        for key in data.allKeys as? [String] ?? [String]()
        {
            if let imgDict = data[key] as? NSDictionary
            {
                photos.append(Photo.initWith(key: key, dictionary: imgDict))
            }
        }
        
        return photos
    }
    
    static func downloadImage(fromUrl url:URL, completionHandler:@escaping (UIImage?) -> ())
    {
        if url.isValid()
        {
            let reference = Storage.storage().reference(forURL: url.absoluteString)
            
            reference.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                if let imageData = data
                {
                    if let image = UIImage(data: imageData)
                    {
                        completionHandler(image)
                    }
                }
                else
                {
                    completionHandler(nil)
                }
            }
        }
        else
        {
            completionHandler(nil)
        }
    }
    
    static func downloadProfilePhoto(forUserID id:String, completionHandler:@escaping (UIImage?) -> ())
    {
        let userQuery = dbRef.child(k_db_users).child(id).child(k_USER_IMGURL)
        userQuery.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let url = dataSnapshot.value as? String
            {
                PhotoController.downloadImage(fromUrl: URL(string: url)!, completionHandler: { (image) in
                    completionHandler(image)
                })
            }
            else
            {
                completionHandler(nil)
            }
        }
    }
    
    //WRITE
    static func addPhotoToAlbum(photo:Photo, album:PhotoAlbum)
    {
        let photoQuery = dbRef.child(k_db_albums).child(album.ID).child(k_PHOTOALBUM_IMAGES).childByAutoId()
        
        let photoDictionary = NSMutableDictionary()
        photoDictionary.setValue(photo.imgUrl?.absoluteString, forKey: k_PHOTO_URL)
        photoDictionary.setValue(photo.filter.rawValue, forKey: k_PHOTO_FILTER)
        photoDictionary.setValue(photo.transform.toArray(), forKey: k_PHOTO_TRANSFORM)
        
        photoQuery.setValue(photoDictionary)
    }
    
    static func addPhotosToAlbum(photos:[Photo], album:PhotoAlbum)
    {
        for photo in photos
        {
            self.addPhotoToAlbum(photo: photo, album: album)
        }
    }
    
    private static func uploadImage(image:UIImage, toFolder folder:String, completionHandler:@escaping (URL?) -> ())
    {
        if let imageData = UIImageJPEGRepresentation(image, 0.5)
        {
            let imageUrlName = String.uniqeKey() + ".jpg"
            
            let imgRef = Storage.storage().reference().child("\(folder)/\(imageUrlName)")
            print(imgRef.fullPath)
            
            _ = imgRef.putData(imageData, metadata: nil) { (metadata, error) in
                
                if let metadata = metadata
                {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata.downloadURL()
                    completionHandler(downloadURL)
                }
                else
                {
                    // Uh-oh, an error occurred!
                    completionHandler(nil)
                }
            }
        }
    }
    
    static func uploadAlbumImage(image:UIImage, completionHandler:@escaping (URL?) -> ())
    {
        self.uploadImage(image: image, toFolder: "albumsImages") { (url) in
            completionHandler(url)
        }
    }
    
    static func uploadImageToAlbum(image: UIImage, photoAlbum: PhotoAlbum?)
    {
        PhotoController.uploadAlbumImage(image: image) { (photoUrl) in
            let photo = Photo.init(withID: "", imgUrl: photoUrl?.absoluteString ?? "", transform: CATransform3DIdentity, filter: FilterType.NoFilter.rawValue)
            photo.img = image
            photoAlbum?.photos.append(photo)
            PhotoController.addPhotoToAlbum(photo: photo, album: photoAlbum!)
        }
    }
    
    static func uploadProfileImage(image:UIImage, forUserID id:String, completionHandler:@escaping (Bool) -> ())
    {
        //TODO: check if need to delete current, or make another function for that
        self.uploadImage(image: image, toFolder: "profileimages") { (url) in
            if let imgUrl = url
            {
                let userQuery = dbRef.child(k_db_users).child(id).child(k_USER_IMGURL)
                userQuery.setValue(imgUrl.absoluteString)
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
            }
        }
    }
    
    //DELETE
    static func deletePhoto(_ photo: Photo, fromAlbum album:PhotoAlbum)
    {
        let photoQuery = dbRef.child(k_db_albums).child(album.ID).child(k_PHOTOALBUM_IMAGES).child(photo.ID)
        
        photoQuery.removeValue()
    }
    
    static func deleteImage(withUrlPath url:String, completionHandler:@escaping (Bool) -> ())
    {
        let reference = Storage.storage().reference(forURL: url)
        
        reference.delete { (err) in
            if let error = err
            {
                print(error)
                completionHandler(false)
            }
            else
            {
                completionHandler(true)
            }
        }
    }
    
    //UPDATE
    static func updatePhoto(_ photo:Photo, atAlbum album:PhotoAlbum)
    {
        let photoQuery = dbRef.child(k_db_albums).child(album.ID).child(k_PHOTOALBUM_IMAGES).child(photo.ID)
        
        let photoDictionary = NSMutableDictionary()
        photoDictionary.setValue(photo.imgUrl?.absoluteString, forKey: k_PHOTO_URL)
        photoDictionary.setValue(photo.filter.rawValue, forKey: k_PHOTO_FILTER)
        photoDictionary.setValue(photo.transform.toArray(), forKey: k_PHOTO_TRANSFORM)
        
        photoQuery.setValue(photoDictionary)
    }
}
