//
//  AlbumsStrategy.swift
//  Memories
//
//  Created by Ilija Antonjevic on 30/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

protocol AlbumsStrategy: class {
    func loadAlbums(completionHandler:@escaping ([PhotoAlbum]) -> ())
}
