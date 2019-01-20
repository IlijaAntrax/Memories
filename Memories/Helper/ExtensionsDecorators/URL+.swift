//
//  URL+.swift
//  Memories
//
//  Created by Ilija Antonijevic on 1/19/19.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation

extension URL
{
    func isValid() -> Bool
    {
        if self.path != "" && self.path != "/"
        {
            return true
        }
        return false
    }
}
