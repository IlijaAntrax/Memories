//
//  String+.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation

extension String
{
    func getDate() -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone.current //Current time zone
        
        return dateFormatter.date(from: self)
    }
    
    static func uniqeKey() -> String
    {
        return NSUUID().uuidString.lowercased() + "_" + "\(Date().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "+")
    }
}
