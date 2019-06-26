//
//  InternalNavigationController.swift
//  Memories
//
//  Created by Ilija Antonjevic on 15/05/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

final class InternalNavigationController
{
    static let sharedInstance: InternalNavigationController = {
        let instance = InternalNavigationController()
        return instance
    }()
    
    
    func getRootViewController() -> UIViewController?
    {
        return getTopViewController(forRootVC: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    func getTopViewController(forRootVC controller: UIViewController?) -> UIViewController?
    {
        var currentController = controller
        var isPresenting = false
        
        repeat {
            let presented = currentController?.presentedViewController
            isPresenting = (presented != nil)
            if (presented != nil) {
                currentController = presented
            }
        } while (isPresenting)
        
        return currentController
    }
    
    //MARK: Navigation
    func navigateToSharedAlbums()
    {
        if let rootVC = self.getRootViewController() as? UITabBarController {
            rootVC.selectedIndex = 1
        } else if let navRootVC = self.getRootViewController() as? UINavigationController {
            navRootVC.dismiss(animated: false) {
                self.navigateToSharedAlbums()
                return
            }
        }
    }
    
    func navigateToSharedAlbum(albumId: String)
    {
        if let rootVC = self.getRootViewController() as? UITabBarController {
            rootVC.selectedIndex = 1
            
            if let sharedAlbumVC = UIApplication.topViewController() as? SharedAlbumsViewController {
                sharedAlbumVC.selectedAlbumID = albumId
                sharedAlbumVC.performSegue(withIdentifier: "SharedAlbumSegueIdentifier", sender: sharedAlbumVC)
            } else {
                if let currentVC = UIApplication.topViewController() {
                    currentVC.navigationController?.popViewController(animated: false)
                    self.navigateToSharedAlbum(albumId: albumId)
                    return
                }
            }
        } else if let navRootVC = self.getRootViewController() as? UINavigationController {
            navRootVC.dismiss(animated: false) {
                self.navigateToSharedAlbums()
                return
            }
        }
    }
    
    func navigateToMyAlbums()
    {
        if let rootVC = self.getRootViewController() as? UITabBarController {
            rootVC.selectedIndex = 0
        } else if let navRootVC = self.getRootViewController() as? UINavigationController {
            navRootVC.dismiss(animated: false) {
                self.navigateToSharedAlbums()
                return
            }
        }
    }
    
    func navigateToMyAlbum(albumId: String)
    {
        if let rootVC = self.getRootViewController() as? UITabBarController {
            rootVC.selectedIndex = 0
            
            if let myAlbumVC = UIApplication.topViewController() as? MyAlbumsViewController {
                myAlbumVC.selectedAlbumID = albumId
                myAlbumVC.performSegue(withIdentifier: "MyAlbumSegueIdentifier", sender: myAlbumVC)
            } else {
                if let currentVC = UIApplication.topViewController() {
                    currentVC.navigationController?.popViewController(animated: false)
                    self.navigateToMyAlbum(albumId: albumId)
                    return
                }
            }
        } else if let navRootVC = self.getRootViewController() as? UINavigationController {
            navRootVC.dismiss(animated: false) {
                self.navigateToSharedAlbums()
                return
            }
        }
    }
}
