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
}
