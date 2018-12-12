//
//  PhotoController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

class PhotoController
{
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
}
