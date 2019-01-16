//
//  UIImage+.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

public extension UIImage
{
    func cropedImage(rect:CGRect) -> UIImage?
    {
        return self.cropedImage(rect: rect, withScale: self.scale)
    }
    
    func cropedImage(rect:CGRect, withScale cropedSacle:CGFloat) -> UIImage?
    {
        let cropRect = CGRect(x: rect.origin.x * self.scale,
                              y: rect.origin.y * self.scale,
                              width: rect.size.width * self.scale,
                              height: rect.size.height * self.scale);
        
        if let imageRef = self.cgImage!.cropping(to: cropRect)
        {
            return UIImage(cgImage: imageRef, scale: cropedSacle, orientation: self.imageOrientation)
        }
        else
        {
            return nil
        }
    }
    
    func getSquaredImage()-> UIImage?
    {
        if self.size.width > self.size.height
        {
            return self.cropedImage(rect: CGRect(x: (self.size.width - self.size.height) / 2.0, y: 0, width: self.size.height, height: self.size.height))
        }
        else
        {
            return self.cropedImage(rect: CGRect(x: 0, y: (self.size.height - self.size.width) / 2.0, width: self.size.width, height: self.size.width))
        }
    }
    
    public class func ninePNGimage(named name:String, withSacle scale:CGFloat) -> UIImage?
    {
        return UIImage(named: name)?.strechable9PNGimageWithScale(preferedScale: scale)
    }
    
    public class func ninePNGimage(data:NSData, withSacle scale:CGFloat) -> UIImage?
    {
        return UIImage(data: data as Data)?.strechable9PNGimageWithScale(preferedScale: scale)
    }
    
    private func strechable9PNGimageWithScale(preferedScale:CGFloat) -> UIImage
    {
        let cropedImage = self.cropedImage(rect: CGRect(x: 1, y: 1, width: self.size.width - 2, height: self.size.height - 2), withScale: preferedScale)
        
        return cropedImage!.resizableImage(withCapInsets: self.getEdgeInsetsFrom9PNGimage(image: self, andScale: preferedScale), resizingMode: UIImageResizingMode.stretch)
    }
    
    /*
     let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
     let alphaValue = dataType[offset]
     let redColor = dataType[offset+1]
     let greenColor = dataType[offset+2]
     let blueColor = dataType[offset+3]
     let alphaFloat = CGFloat(alphaValue)/255.0
     let redFloat = CGFloat(redColor)/255.0
     let greenFloat = CGFloat(greenColor)/255.0
     let blueFloat = CGFloat(blueColor)/255.0
     */
    
    private func getEdgeInsetsFrom9PNGimage(image:UIImage , andScale preferedScale:CGFloat) -> UIEdgeInsets
    {
        let inImage:CGImage = self.cgImage!
        
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData :UnsafeMutablePointer<UInt8>? = nil
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        context.clear(rect)
        context.draw(inImage, in: rect)
        
        let pixelData = context.makeImage()!.dataProvider!.data
        let dataType: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData!)
        
        var top:CGFloat = 0
        var left:CGFloat = 0
        var bottom:CGFloat = 0
        var right:CGFloat = 0
        
        for i in 1..<pixelsWide
        {
            let offset = 4*(i)
            let alpha = CGFloat(dataType[offset])/255.0
            if alpha == 1
            {
                right = CGFloat(i)
            }
            else if right == 0
            {
                left = CGFloat(i)
            }
            else
            {
                break;
            }
        }
        
        if left != 0
        {
            left += 1
        }
        
        
        for i in 1..<pixelsHigh
        {
            let offset = 4*(Int(pixelsWide) * i)
            let alpha = CGFloat(dataType[offset])/255.0
            
            if alpha == 1
            {
                bottom = CGFloat(i)
            }
            else if bottom == 0
            {
                top = CGFloat(i)
            }
            else
            {
                break;
            }
        }
        if top != 0
        {
            top += 1
        }
        
        bottom = CGFloat(pixelsHigh)-bottom
        right = CGFloat(pixelsWide)-right
        
        let insets = UIEdgeInsetsMake(top/preferedScale, left/preferedScale, bottom/preferedScale, right/preferedScale)
        return insets
    }
    
    func pixelColor(atSposition position:CGPoint)-> UIColor
    {
        let inImage:CGImage = self.cgImage!
        
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData :UnsafeMutablePointer<UInt8>? = nil
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        context!.clear(rect)
        context!.draw(inImage, in: rect)
        let data = context!.data
        let dataType = data!.assumingMemoryBound(to: UInt8.self)
        
        let offset = 4*Int(pixelsWide)*Int(position.y) + 4*Int(position.x)
        
        let alphaValue = dataType[offset]
        let redColor = dataType[offset+1]
        let greenColor = dataType[offset+2]
        let blueColor = dataType[offset+3]
        
        
        let alphaFloat = CGFloat(alphaValue)/255.0
        let redFloat = CGFloat(redColor)/255.0
        let greenFloat = CGFloat(greenColor)/255.0
        let blueFloat = CGFloat(blueColor)/255.0
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
    }
    
    
    func imageWithColor(color : UIColor) -> UIImage
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, self.scale)
        let c = UIGraphicsGetCurrentContext()
        self.draw(in: rect)
        
        c!.setFillColor(color.cgColor)
        c!.setBlendMode(CGBlendMode.sourceAtop)
        c!.fill(rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
    public func applyLightEffect() -> UIImage? {
        return applyBlurWithRadius(blurRadius: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    public func applyExtraLightEffect() -> UIImage? {
        return applyBlurWithRadius(blurRadius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    public func applyDarkEffect() -> UIImage? {
        return applyBlurWithRadius(blurRadius: 20, tintColor: UIColor(white: 0.11, alpha: 0.5), saturationDeltaFactor: 1.8)
    }
    
    public func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return applyBlurWithRadius(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    public func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if self.cgImage == nil {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(maskImage!)")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(Float.ulpOfOne)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectInContext = UIGraphicsGetCurrentContext()!
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(self.cgImage!, in: imageRect)
            
            
            var effectInBuffer = createEffectBuffer(context: effectInContext)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectOutContext = UIGraphicsGetCurrentContext()!
            
            var effectOutBuffer = createEffectBuffer(context: effectOutContext)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                
                let inputRadius = blurRadius * screenScale
                let koren = CGFloat(sqrt(2 * Double.pi))
                var radius = UInt32(floor(inputRadius * 3.0 * koren / 4 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext!.scaleBy(x: 1.0, y: -1.0)
        outputContext!.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext!.draw(self.cgImage!, in: imageRect)
        // CGContextDrawImage(outputContext!, imageRect, self.cgImage!)
        
        // Draw effect image.
        if hasBlur {
            outputContext!.saveGState()
            if let image = maskImage {
                outputContext!.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext!.draw(effectImage.cgImage!, in: imageRect)
            outputContext!.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext!.saveGState()
            outputContext!.setFillColor(color.cgColor)
            outputContext!.fill(imageRect)
            outputContext!.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    func scaledToSize(size: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func areaAverage() -> UIColor
    {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        let context = CIContext()
        let inputImage: CIImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
    func getAlphaComponentOffsets() -> [Int]
    {
        var offsetsArray = [Int]()
        
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return offsetsArray
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return offsetsArray
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return offsetsArray
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height)
        {
            for column in 0 ..< Int(width)
            {
                let offset = row * width + column
                
                if pixelBuffer[offset].alphaComponent == 0
                {
                    offsetsArray.append(offset)
                    //pixelBuffer[offset] = color
                }
            }
        }
        
        //        let outputCGImage = context.makeImage()!
        //        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        //
        //        return (outputImage,offsetsArray)
        return offsetsArray
    }
    
    func setColor(offsetPixels: [Int], color: RGBA32) -> UIImage?
    {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for offset in offsetPixels
        {
            pixelBuffer[offset] = color
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    public func fixedOrientation(isCameraFront: Bool) -> UIImage
    {
        if imageOrientation == UIImageOrientation.up {
            return self
        }
        //front camera je right orientation, a i back camera je tako da ovu funkciju prepravljam samo za ovu orijantaciju
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        //        print("imageorientation: \(imageOrientation)")
        
        switch imageOrientation
        {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2.0))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:    //ovaj deo radi do break
            if isCameraFront
            {
                transform = transform.translatedBy(x: size.width, y: size.height)
                transform = transform.scaledBy(x: -1, y: 1)
                transform = transform.rotated(by: CGFloat(-Double.pi/2.0))
            }
            else
            {
                transform = transform.translatedBy(x: 0, y: size.height)
                transform = transform.scaledBy(x: 1, y: 1)
                transform = transform.rotated(by: CGFloat(-Double.pi/2.0))
            }
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation
        {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
    
    func alpha(_ value:CGFloat) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

public struct RGBA32: Equatable
{
    private var color: UInt32
    
    var redComponent: UInt8
    {
        return UInt8((color >> 24) & 255)
    }
    
    var greenComponent: UInt8
    {
        return UInt8((color >> 16) & 255)
    }
    
    var blueComponent: UInt8
    {
        return UInt8((color >> 8) & 255)
    }
    
    var alphaComponent: UInt8
    {
        return UInt8((color >> 0) & 255)
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)
    {
        //color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
        color = 24
    }
    
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
    
    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
    
    public static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool
    {
        return lhs.color == rhs.color
    }
}
