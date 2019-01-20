//
//  Date+.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/19/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

extension Date
{
    func getString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone.current //Current time zone
        
        return dateFormatter.string(from: self)
    }
}
