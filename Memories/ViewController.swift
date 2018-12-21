//
//  ViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 11/15/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        test()
    }
    
    func test()
    {
        //UserController.getUser(forEmail: "st_antrax_pa@gmail.com") { (user) in }
        //UserController.getUser(forID: "userskey_2g2iXujeV5MvXIcFolkxcB94gNu1") { (user) in }
        //UserController.getUsersOnAlbum(forAlbumId: "-L554opJg3yrXVnJCshW") { (users) in }
        //PhotoAlbumController.getAlbum(forAlbumId: "-L554opJg3yrXVnJCshW") { (photoAlbum) in }
        //PhotoAlbumController.getAlbums(forUserId: "st_antrax") { (albums) in }
        //PhotoAlbumController.getSharedAlbums(forUserId: "userskey_sqG4983JzOMShuJ8g4VnVgZKu3G3") { (albums) in }
        //PhotoAlbumController.getSharedAlbums(forUserEmail: "st_antrax_pa@gmail.com") { (albums) in }
        //RemoteNotificationController.getNotifications(forUserId: "userskey_2g2iXujeV5MvXIcFolkxcB94gNu1") { (notifications) in }
        
        //UserController.addMyAccount(user: User.init(withID: "userskey_sqG4983JzOMShuJ8g4VnVgZKu3G3", username: "bobinesovic", email: "bobinesovic_pa@gmail.com", firstname: "Slobodan", lastname: "Nesovic", imgUrl: "fakeUrl"))
        //UserController.addUserOnAlbum(user: User.init(withID: "userskey_sqG4983JzOMShuJ8g4VnVgZKu3G3", username: "bobinesovic", email: "bobinesovic_pa@gmail.com", firstname: "Slobodan", lastname: "Nesovic", imgUrl: "fakeUrl"), album: PhotoAlbum.init(withID: "-L554opJg3yrXVnJCshW", name: "Amsterdam", date: Date(), owner: "st_antrax", photos: [Photo]()))
        //PhotoAlbumController.addPhotoAlbum(album: PhotoAlbum.init(withID: "", name: "Bukurest", date: Date(), owner: "st_antrax_pa@gmail.com", photos: [Photo]()))
        //PhotoController.deletePhotoFromAlbum(photo: Photo.init(withID: "-L6_qCG-uOLD9PZRCfcy", imgUrl: "", transform: CATransform3D.init(), filter: 1))
        //PhotoAlbumController.deletePhotoAlbum(PhotoAlbum.init(withID: "albumkey1", name: "", date: Date(), owner: "", photos: [Photo]()))
    }

}

