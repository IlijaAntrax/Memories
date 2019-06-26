//
//  Photo.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/11/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit
import Photos

let k_PHOTO_URL = "url"
let k_PHOTO_TRANSFORM = "transform"
let k_PHOTO_FILTER = "filter"

class Photo: NSObject
{
    private var _id: String?
    var img: UIImage?
    var imgUrl: URL?
    var transform = CATransform3DIdentity
    var filter: FilterType = FilterType.NoFilter
    
    var ID:String
    {
        get
        {
            return self._id ?? ""
        }
        set
        {
            self._id = newValue
        }
    }
    
    init(withID id:String, imgUrl:String, transform:CATransform3D, filter:Int)
    {
        self._id = id
        self.imgUrl = URL(string: imgUrl)
        self.transform = transform
        self.filter = FilterType(rawValue: filter)!
    }
    
    class func initWith(key:String, dictionary:NSDictionary) -> Photo
    {
        return Photo(withID: key,
                     imgUrl: (dictionary[k_PHOTO_URL] as? String) ?? "",
                     transform: CATransform3D.initFrom(transformData: (dictionary[k_PHOTO_TRANSFORM] as? [CGFloat]) ?? [CGFloat]()),
                     filter: (dictionary[k_PHOTO_FILTER] as? Int) ?? 0)
    }
    
}
