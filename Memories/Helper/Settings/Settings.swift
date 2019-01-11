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
    
    //MARK: Colors
    func primaryColor() -> UIColor
    {
        return UIColor.init(red: 80/255, green: 109/255, blue: 238/255, alpha: 1.0)
    }
    
    func secondaryColor() -> UIColor
    {
        return UIColor.white
    }
    
    func grayLightColor() -> UIColor
    {
        return UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    }
    
    func grayNormalColor() -> UIColor
    {
        return UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
    }

    func grayDarkColor() -> UIColor
    {
        return UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    //MARK: Fonts
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
