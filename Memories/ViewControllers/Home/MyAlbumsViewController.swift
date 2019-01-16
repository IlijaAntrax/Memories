//
//  MyAlbumsViewController.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/11/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class MyAlbumsViewController: HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func loadAlbum(completionHandler: @escaping ([PhotoAlbum]) -> ()) {
        PhotoAlbumController.getAlbums(forUserEmail: MyAccount.sharedInstance.email ?? "") { (albums) in
            completionHandler(albums)
        }
    }

}
