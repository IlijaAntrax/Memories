//
//  Notification+.swift
//  Memories
//
//  Created by Ilija Antonijevic on 6/25/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didChangeAlbumData = Notification.Name("didChangeAlbumData")
    static let didAddAlbumUsers = Notification.Name("didAddAlbumUsers")
    static let imageEditingBegan = Notification.Name("TouchesBeganNotification")
    static let imageEditingEnded = Notification.Name("TouchesEndedNotification")
}
