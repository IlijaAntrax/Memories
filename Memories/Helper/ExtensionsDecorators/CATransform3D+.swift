//
//  CATransform3D+.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/12/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

extension CATransform3D
{
    static func initFrom(transformData:[CGFloat]) -> CATransform3D
    {
        return CATransform3D.init(m11: transformData[0], m12: transformData[1], m13: transformData[2], m14: transformData[3], m21: transformData[4], m22: transformData[5], m23: transformData[6], m24: transformData[7], m31: transformData[8], m32: transformData[9], m33: transformData[10], m34: transformData[11], m41: transformData[12], m42: transformData[13], m43: transformData[14], m44: transformData[15])
    }
    
    func toArray() -> [CGFloat]
    {
        return [self.m11, self.m12, self.m13, self.m14, self.m21, self.m22, self.m23, self.m24, self.m31, self.m32, self.m33, self.m34, self.m41, self.m42, self.m43, self.m44]
    }
}
