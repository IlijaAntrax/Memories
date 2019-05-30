//
//  SharedAlbumsStrategy.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

class SharedAlbumsStrategy:AlbumsStrategy
{
    func loadAlbums(completionHandler: @escaping ([PhotoAlbum]) -> ()) {
        if let email = MyAccount.sharedInstance.userId {
            PhotoAlbumController.getSharedAlbums(forUserId:  email) { (albums) in
                completionHandler(albums)
            }
        } else {
            completionHandler([PhotoAlbum]())
        }
    }
    
}
