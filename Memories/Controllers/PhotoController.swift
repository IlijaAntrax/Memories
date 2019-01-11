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
        let reference = Storage.storage().reference(forURL: url.absoluteString)
        
        reference.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
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
    
    static func uploadImage(image:UIImage, completionHandler:@escaping (URL?) -> ())
    {
        if let imageData = UIImageJPEGRepresentation(image, 1.0)
        {
            let imageUrlName = String.uniqeKey() + ".jpg"
            
            let imgRef = Storage.storage().reference().child("albumsImages/\(imageUrlName)")
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
}
