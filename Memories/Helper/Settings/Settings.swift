//
//  Settings.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/10/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

let k_KEYBOARD_ANIM_DURATION = 0.3

class Settings: NSObject
{
    
    static let sharedInstance: Settings = {
        let instance = Settings()
        // setup code
        return instance
    }()
    
    
    func isPhone() -> Bool
    {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func fontRegularSizeSmall() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Regular", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.035) : (UIScreen.main.bounds.size.width * 0.0275))!
    }
    func fontBoldSizeSmall() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Bold", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.035) : (UIScreen.main.bounds.size.width * 0.0275))!
    }
    
    func fontRegularSizeMedium() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Regular", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.05) : (UIScreen.main.bounds.size.width * 0.04))!
    }
    func fontBoldSizeMedium() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Bold", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.05) : (UIScreen.main.bounds.size.width * 0.04))!
    }
    
    func fontRegularSizeLarge() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Regular", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.07) : (UIScreen.main.bounds.size.width * 0.0575))!
    }
    func fontBoldSizeLarge() -> UIFont
    {
        return UIFont(name: "SFProDisplay-Bold", size: isPhone() ? (UIScreen.main.bounds.size.width * 0.07) : (UIScreen.main.bounds.size.width * 0.0575))!
    }
}
