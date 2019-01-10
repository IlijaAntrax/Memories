//
//  FilterStore.swift
//  Memories
//
//  Created by Ilija Antonijevic on 12/11/18.
//  Copyright © 2018 Ilija Antonijevic. All rights reserved.
//

import Foundation
import UIKit

enum FilterType : Int
{
    case NoFilter = 0
    case Walden//14
    case Mare9//46
    case Fade//19
    case Willow//8
    case Mare13//50
    case Rise//3
    case Mare5//42
    case F1997//17
    case Mare12//49
    case EarlyBird//10
    case Toaster//12
    case Hudson//4
    case Sutro//11
    case Mare11//48
    case Mare15//52
    case Mare7//4
    case Amaro //1
    case Mayfair//2
    case Valencia//5
    case xPro//6
    case Sierra//7
    case LoFi//9
    case Brannan//13
    case Hefe//15
    case Nashville//16
    case Kelvin//18
    case Instant//20
    case Mare1//38
    case Mare2//39
    case Mare4//41
    case Mare6//43
    case Mare8//45
    case Mare10//47
    case Mare14//51
    case Mare16
    case Mare21
    case ComicEffect
    
    case minimumComponent
    case maximumComponent
    case circularScreen//22
    case dotScreen//23
    case lineScreen//25
    
    case cmykHalfTone//34 !
    
    case BlackAndWhite
    
    
    static func filtersNumber() -> Int
    {
        return FilterType.BlackAndWhite.rawValue + 1
    }
    
    static func filtersUnlocked() -> Int
    {
        return filtersNumber() / 3
    }
    
    static func getFiltersWithNoIntesity() -> [FilterType]
    {
        return [FilterType.NoFilter, FilterType.ComicEffect, FilterType.Instant, FilterType.Fade,
                FilterType.cmykHalfTone, FilterType.lineScreen, FilterType.dotScreen,
                FilterType.circularScreen, FilterType.maximumComponent, FilterType.minimumComponent , FilterType.Mare21]
    }
}

class FilterStore
{
    static let shared: FilterStore = { FilterStore() }()
    let vividContext = CIContext(options: [kCIContextWorkingColorSpace : CGColorSpaceCreateDeviceRGB()])
    let context = CIContext(options: nil)
    
    let CategoryCustomFilters = "Custom Filters"
    
    init()
    {
        
    }
    
    class func applyInvertFilter(image: UIImage?) -> UIImage?
    {
        var curentImage = CIImage(image: image!)
        
        if let filter = CIFilter(name: "CIColorInvert")
        {
            filter.setValue(curentImage, forKey: kCIInputImageKey)
            
            curentImage = filter.outputImage
            
            let finalImage = FilterStore.shared.context.createCGImage(curentImage!, from: curentImage!.extent)!
            
            return UIImage(cgImage: finalImage)
        }
        
        return nil
    }
    
    class func replaceAlpha(ofImage image:UIImage, withColor color: UIColor) -> UIImage?
    {
        let inImage:CGImage = image.cgImage!
        
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        //print(pixelsWide)
        //print(pixelsHigh)
        
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData :UnsafeMutablePointer<UInt8>? = nil
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        context!.clear(rect)
        context?.draw(inImage, in: rect)
        
        //        let pixelData = context!.makeImage()!.dataProvider!.data
        //        var dataType: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData!)
        //
        //        for i in 0...pixelsWide
        //        {
        //            for j in 0...pixelsHigh
        //            {
        //                let position = CGPoint(x: i, y: j)
        //
        //                let offset = 4*Int(pixelsWide)*Int(position.y) + 4*Int(position.x)
        //
        //                let alphaValue = dataType[offset]
        //                let redColor = dataType[offset+1]
        //                let greenColor = dataType[offset+2]
        //                let blueColor = dataType[offset+3]
        //
        //                if alphaValue == 0
        //                {
        //
        //                }
        //            }
        //        }
        
        return image
    }
    
    class func applyBrightness(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIColorControls")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 1.6 - 0.8, forKey: kCIInputBrightnessKey)
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyContrast(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIColorControls")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 3.75 + 0.25, forKey: kCIInputContrastKey)
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applySaturation(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIColorControls")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 2.0, forKey: kCIInputSaturationKey)
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyExposure(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIExposureAdjust")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 10.0 - 5.0, forKey: "inputEV")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyHighlights(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIHighlightShadowAdjust")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 0.7 + 0.3, forKey: "inputHighlightAmount")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyShadows(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIHighlightShadowAdjust")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 2.0 - 1.0, forKey: "inputShadowAmount")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyVibrance(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIVibrance")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 2.0 - 1.0, forKey: "inputAmount")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyHue(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIHueAdjust")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(value * 6.28 - 3.14, forKey: "inputAngle")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyWarmth(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CITemperatureAndTint")
            {
                filter.setValue(input, forKey: kCIInputImageKey)
                filter.setValue(CIVector(cgPoint: CGPoint(x: value * 18000 + 4000, y: 0)), forKey: "inputNeutral")
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func applyShade(input: CIImage?, with value: Double)-> CIImage?
    {
        if let input = input
        {
            if let filter = CIFilter(name: "CIVignetteEffect")
            {
                filter.setValue(CIVector(x: input.extent.width / 2.0, y: input.extent.height / 2.0), forKey: kCIInputCenterKey)
                filter.setValue(input.extent.size.width * CGFloat(1 - value), forKey: kCIInputRadiusKey)
                //filter.setValue(value, forKey: kCIInputIntensityKey)
                filter.setValue(input, forKey: kCIInputImageKey)
                return filter.outputImage
            }
        }
        return nil
    }
    
    class func filterImage(image : UIImage?, filterType : FilterType, intensity: Float) -> UIImage?
    {
        guard let image = image else { return nil }
        var filters = [CIFilter]()
        var imageToReturn: UIImage?
        
        autoreleasepool
            {
                switch filterType
                {
                case .NoFilter:
                    imageToReturn = image
                case .Amaro:
                    filters = amaroFilter(intensity: CGFloat(intensity))
                case .Mayfair:
                    filters = mayfairFilter(intensity: CGFloat(intensity))
                case .Rise:
                    filters = riseFilter(intensity: CGFloat(intensity))
                case .Hudson:
                    filters = hudsonFilter(intensity: CGFloat(intensity))
                case .Valencia:
                    filters = valenciaFilter(intensity: CGFloat(intensity))
                case .xPro:
                    filters = xProFilter(intensity: CGFloat(intensity))
                case .Sierra:
                    filters = sierraFilter(intensity: CGFloat(intensity))
                case .Willow:
                    filters = willowFilter(intensity: CGFloat(intensity))
                case .LoFi:
                    filters = loFiFilter(intensity: CGFloat(intensity))
                case .EarlyBird:
                    filters = earlyBirdFilter(intensity: CGFloat(intensity))
                case .Sutro:
                    filters = sutroFilter(intensity: CGFloat(intensity))
                case .Toaster:
                    filters = toasterFilter(intensity: CGFloat(intensity))
                case .Brannan:
                    filters = brannanFilter(intensity: CGFloat(intensity))
                case .Walden:
                    filters = walderFilter(intensity: CGFloat(intensity))
                case .Hefe:
                    filters = hefeFilter(intensity: CGFloat(intensity))
                case .Nashville:
                    filters = nashvilleFilter(intensity: CGFloat(intensity))
                case .F1997:
                    filters = f1977Filter(intensity: CGFloat(intensity))
                case .Kelvin:
                    filters = kelvinFilter(intensity: CGFloat(intensity))
                case .Fade:
                    filters = fadeFilter(intensity: CGFloat(intensity))
                case .Instant:
                    filters = instantFilter(intensity: CGFloat(intensity))
                case .ComicEffect:
                    filters = comicEffectFilter(intensity: CGFloat(intensity))
                case .Mare1:
                    filters = mare1Filter(intensity: CGFloat(intensity))
                case .Mare2:
                    filters = mare2Filter(intensity: CGFloat(intensity))
                case .Mare4:
                    filters = mare4Filter(intensity: CGFloat(intensity))
                case .Mare5:
                    filters = mare5Filter(intensity: CGFloat(intensity))
                case .Mare6:
                    filters = mare6Filter(intensity: CGFloat(intensity))
                case .Mare7:
                    filters = mare7Filter(intensity: CGFloat(intensity))
                case .Mare8:
                    filters = mare8Filter(intensity: CGFloat(intensity))
                case .Mare9:
                    filters = mare9Filter(intensity: CGFloat(intensity))
                case .Mare10:
                    filters = mare10Filter(intensity: CGFloat(intensity))
                case .Mare11:
                    filters = mare11Filter(intensity: CGFloat(intensity))
                case .Mare12:
                    filters = mare12Filter(intensity: CGFloat(intensity))
                case .Mare13:
                    filters = mare13Filter(intensity: CGFloat(intensity))
                case .Mare14:
                    filters = mare14Filter(intensity: CGFloat(intensity))
                case .Mare15:
                    filters = mare15Filter(intensity: CGFloat(intensity))
                case .Mare16:
                    filters = mare16Filter(intensity: CGFloat(intensity))
                case .Mare21:
                    filters = mare21Filter()
                case .BlackAndWhite:
                    filters = blackAndWhiteFilter(intensity: CGFloat(intensity))
                    
                case .minimumComponent:
                    filters = minimumComponentFilter()
                case .maximumComponent:
                    filters = maximumComponentFilter()
                    
                case .cmykHalfTone:
                    filters = CMYKHalftoneFilter(image)
                case .circularScreen:
                    filters = circularScreenFilter(image)
                case .dotScreen:
                    filters = dotScreenFilter(image)
                case .lineScreen:
                    filters = lineScreenFilter(image)
                }
                
                if filters.count > 0
                {
                    var currentFilteringImage = CIImage(image: image)
                    
                    for filter in filters
                    {
                        filter.setValue(currentFilteringImage, forKey: kCIInputImageKey)
                        currentFilteringImage = filter.outputImage!
                    }
                    
                    var finalCGImage : CGImage
                    if filters[0].name == "YUCIRGBToneCurve"
                    {
                        finalCGImage = FilterStore.shared.vividContext.createCGImage(currentFilteringImage!, from: currentFilteringImage!.extent)!
                    }
                    else
                    {
                        finalCGImage = FilterStore.shared.context.createCGImage(currentFilteringImage!, from: currentFilteringImage!.extent)!
                    }
                    
                    imageToReturn = UIImage(cgImage: finalCGImage)
                }
        }
        return imageToReturn
    }
    
    //MARK: Custom filters
    class func chromaticAberrationFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "ChromaticAberration")
        {
            filter.setValue(3.17, forKey: "inputAngle")
            filter.setValue(image.size.height / 90.0, forKey: "inputRadius")
            return [filter]
        }
        
        return []
    }
    
    class func differenceOfGuassiansFilter() -> [CIFilter]
    {
        if let filter = CIFilter(name: "DifferenceOfGaussians")
        {
            filter.setValue(0.75, forKey: "inputSigma0")
            filter.setValue(3.25, forKey: "inputSigma1")
            return [filter]
        }
        
        return []
    }
    
    class func eightBitFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "EightBit")
        {
            filter.setValue(4.0, forKey: "inputPaletteIndex")
            filter.setValue(image.size.width / 64.0, forKey: "inputScale")
            return [filter]
        }
        
        return []
    }
    
    
    class func scatterWarpFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "ScatterWarp")
        {
            
            var inputScatterRadiusValue = image.size.height / 64.0
            if inputScatterRadiusValue < 10.0
            {
                inputScatterRadiusValue = 10.0
            }
            
            filter.setDefaults()
            filter.setValue(inputScatterRadiusValue, forKey: "inputScatterRadius")
            return [filter]
        }
        
        return []
    }
    
    class func starBurstFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "StarBurstFilter")
        {
            filter.setDefaults()
            filter.setValue(0.95, forKey: "inputThreshold")
            filter.setValue(image.size.width / 8.0, forKey: "inputRadius")
            filter.setValue(1.75, forKey: "inputAngle")
            filter.setValue(4.8, forKey: "inputBeamCount")
            filter.setValue(-0.19, forKey: "inputStarburstBrightness")
            return [filter]
        }
        
        return []
    }
    
    class func VHSTrackingLinesFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "VHSTrackingLines")
        {
            let inputSpacingValue = image.size.height / 12.0
            let inputTimeValue = image.size.height * 0.8
            let inputStripeHeight = (image.size.height / 1500.0)
            
            filter.setValue(inputTimeValue, forKey: "inputTime")
            filter.setValue(inputSpacingValue, forKey: "inputSpacing")
            filter.setValue(inputStripeHeight, forKey: "inputStripeHeight")
            filter.setValue(0.1, forKey: "inputBackgroundNoise")
            return [filter]
        }
        
        return []
    }
    
    class func CMYKHalftoneFilter(_ image : UIImage) -> [CIFilter]
    {
        var inputCenterValue = image.size.width / 91.0
        if image.size.width == 200
        {
            inputCenterValue = 7.0
        }
        if let filter = CIFilter(name: "CICMYKHalftone")
        {
            filter.setValue(CIVector(x: image.size.width / 2.0, y: image.size.height), forKey: kCIInputCenterKey)
            filter.setValue(inputCenterValue, forKey: kCIInputWidthKey)
            filter.setValue(2.3, forKey: kCIInputAngleKey)
            filter.setValue(0.5, forKey: kCIInputSharpnessKey)
            filter.setValue(0.5, forKey: "inputGCR")
            filter.setValue(0.5, forKey: "inputUCR")
            return [filter]
        }
        
        return []
    }
    
    class func circularScreenFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CICircularScreen")
        {
            filter.setValue(CIVector(x: image.size.width, y: image.size.height), forKey: kCIInputCenterKey)
            filter.setValue(image.size.width / 70.0, forKey: kCIInputWidthKey)
            filter.setValue(0.5, forKey: kCIInputSharpnessKey)
            return [filter]
        }
        
        return []
    }
    
    class func dotScreenFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIDotScreen")
        {
            filter.setValue(1.0, forKey: kCIInputAngleKey)
            filter.setValue(image.size.width / 49.0, forKey: kCIInputWidthKey)
            filter.setValue(0.17, forKey: kCIInputSharpnessKey)
            return [filter]
        }
        
        return []
    }
    
    class func lineScreenFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CILineScreen")
        {
            filter.setValue(1.1, forKey: kCIInputAngleKey)
            filter.setValue(image.size.width / 160.0, forKey: kCIInputWidthKey)
            filter.setValue(0.35, forKey: kCIInputSharpnessKey)
            return [filter]
        }
        
        return []
    }
    
    class func comicEffectFilter() -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIComicEffect")
        {
            return [filter]
        }
        
        return []
    }
    
    class func crystallizeFilter(_ image : UIImage) -> [CIFilter]
    {
        var filtersToReturn = [CIFilter]()
        
        print("ImageSize: \(image.size)")
        
        var radiusValue = image.size.width / 20.0
        
        if image.size.width == 200
        {
            radiusValue = 13.0
        }
        
        print("RadiusValue: \(radiusValue)")
        
        if let filter = CIFilter(name: "CICrystallize")
        {
            filter.setValue(radiusValue, forKey: kCIInputRadiusKey)
            filter.setValue(CIVector(x: image.size.width / 2.0, y: image.size.height / 2.0), forKey: kCIInputCenterKey)
            filtersToReturn.append(filter)
        }
        
        return filtersToReturn
    }
    
    class func pointillizeFilter(_ image : UIImage) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIPointillize")
        {
            filter.setValue(image.size.width / 128.0, forKey: kCIInputRadiusKey)
            return [filter]
        }
        
        return []
    }
    
    //default filters
    class func amaroFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0, y: (0.0 + 19.0 * intensity) / 255.0),
                                          CIVector(x: 30.0 / 255.0, y: (30.0 + 32.0 * intensity) / 255.0),
                                          CIVector(x: 82.0 / 255.0, y: (82.0 + 66.0 * intensity) / 255.0),
                                          CIVector(x: 128.0 / 255.0, y: (128.0 + 60.0 * intensity) / 255.0),
                                          CIVector(x: 145.0 / 255.0, y: (145.0 + 55.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 5.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0, y: 0.0),
                                             CIVector(x: 48.0 / 255.0, y: (48.0 + 24.0 * intensity) / 255.0),
                                             CIVector(x: 115.0 / 255.0, y: (115.0 + 73.0 * intensity) / 255.0),
                                             CIVector(x: 160.0 / 255.0, y: (160.0 + 60.0 * intensity) / 255.0),
                                             CIVector(x: 233.0 / 255.0, y: (233.0 + 12.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0, y: (0.0 + 25.0 * intensity) / 255.0),
                                            CIVector(x: 35.0 / 255.0, y: (80.0 + 45.0 * intensity) / 255.0),
                                            CIVector(x: 106.0 / 255.0, y: (106.0 + 69.0 * intensity) / 255.0),
                                            CIVector(x: 151.0 / 255.0, y: (151.0 + 37.0 * intensity) / 255.0),
                                            CIVector(x: 215.0 / 255.0, y: 215.0 / 255.0),
                                            CIVector(x: 240.0 / 255.0, y: (240.0 - 5.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 5.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mayfairFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 85.0 / 255.0, y: (85.0 + 25.0 * intensity) / 255.0),
                                          CIVector(x: 125.0 / 255.0, y: (125.0 + 45.0 * intensity) / 255.0),
                                          CIVector(x: 221.0 / 255.0, y: (221.0 + 11.0 * intensity) / 255.0),
                                          CIVector(x: 254.0 / 255.0, y: (254.0 - 12.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 40.0 / 255.0, y: (40.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 80.0 / 255.0, y: (80.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 142.0 / 255.0, y: (142.0 + 54.0 * intensity) / 255.0),
                                             CIVector(x: 188.0 / 255.0, y: (188.0 + 27.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 20.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 15.0 * intensity) / 255.0),
                                            CIVector(x: 45.0 / 255.0, y: (40.0 + 15.0 * intensity) / 255.0),
                                            CIVector(x: 85.0 / 255.0, y: (85.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 135.0 / 255.0, y: (135.0 + 50.0 * intensity) / 255.0),
                                            CIVector(x: 182.0 / 255.0, y: (182.0 + 33.0 * intensity) / 255.0),
                                            CIVector(x: 235.0 / 255.0, y: (235.0 - 5.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 30.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func riseFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 25.0 * intensity) / 255.0),
                                          CIVector(x: 30.0 / 255.0, y: (30.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 130.0 / 255.0, y: (130.0 + 62.0 * intensity) / 255.0),
                                          CIVector(x: 170.0 / 255.0, y: (170.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 233.0 / 255.0, y: 233.0 / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 25.0 * intensity) / 255.0),
                                             CIVector(x: 30.0 / 255.0, y: (30.0 + 42.0 * intensity) / 255.0),
                                             CIVector(x: 65.0 / 255.0, y: (65.0 + 53.0 * intensity) / 255.0),
                                             CIVector(x: 100.0 / 255.0, y: (100.0 + 58.0 * intensity) / 255.0),
                                             CIVector(x: 152.0 / 255.0, y: (152.0 + 43.0 * intensity) / 255.0),
                                             CIVector(x: 210.0 / 255.0, y: (210.0 + 20.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 35.0 * intensity) / 255.0),
                                            CIVector(x: 40.0 / 255.0, y: (40.0 + 35.0 * intensity) / 255.0),
                                            CIVector(x: 82.0 / 255.0, y: (82.0 + 42.0 * intensity) / 255.0),
                                            CIVector(x: 120.0 / 255.0, y: (120.0 + 42.0 * intensity) / 255.0),
                                            CIVector(x: 175.0 / 255.0, y: (175.0 + 13.0 * intensity) / 255.0),
                                            CIVector(x: 220.0 / 255.0, y: (220.0 - 6.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
        
    }
    
    class func hudsonFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 35.0 * intensity) / 255.0),
                                          CIVector(x: 42.0 / 255.0, y: (42.0 + 26.0 * intensity) / 255.0),
                                          CIVector(x: 85.0 / 255.0, y: (85.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 124.0 / 255.0, y: (124.0 + 43.0 * intensity) / 255.0),
                                          CIVector(x: 170.0 / 255.0, y: (170.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 215.0 / 255.0, y: (215.0 + 13.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 45.0 / 255.0, y: (45.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 102.0 / 255.0, y: (102.0 + 33.0 * intensity) / 255.0),
                                             CIVector(x: 140.0 / 255.0, y: (140.0 + 42.0 * intensity) / 255.0),
                                             CIVector(x: 192.0 / 255.0, y: (192.0 + 23.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 24.0 / 255.0, y: (24.0 + 18.0 * intensity) / 255.0),
                                            CIVector(x: 60.0 / 255.0, y: (60.0 + 40.0 * intensity) / 255.0),
                                            CIVector(x: 105.0 / 255.0, y: (105.0 + 65.0 * intensity) / 255.0),
                                            CIVector(x: 145.0 / 255.0, y: (145.0 + 63.0 * intensity) / 255.0),
                                            CIVector(x: 210.0 / 255.0, y: (210.0 + 25.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 10.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
        
    }
    
    class func valenciaFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 20.0 * intensity) / 255.0),
                                          CIVector(x: 50.0 / 255.0, y: (50.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 85.0 / 255.0, y: (85.0 + 35.0 * intensity) / 255.0),
                                          CIVector(x: 128.0 / 255.0, y: (128.0 + 34.0 * intensity) / 255.0),
                                          CIVector(x: 228.0 / 255.0, y: (228.0 - 4.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 15.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 18.0 / 255.0, y: (18.0 - 4.0 * intensity) / 255.0),
                                             CIVector(x: 60.0 / 255.0, y: (60.0 + 10.0 * intensity) / 255.0),
                                             CIVector(x: 104.0 / 255.0, y: (104.0 + 24.0 * intensity) / 255.0),
                                             CIVector(x: 148.0 / 255.0, y: (148.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 212.0 / 255.0, y: (212.0 + 12.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 42.0 / 255.0, y: (42.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 80.0 / 255.0, y: (80.0 + 24.0 * intensity) / 255.0),
                                            CIVector(x: 124.0 / 255.0, y: (124.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 170.0 / 255.0, y: (170.0 + 12.0 * intensity) / 255.0),
                                            CIVector(x: 220.0 / 255.0, y: (220.0 - 10.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 15.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
        
    }
    
    class func xProFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 42.0 / 255.0, y: (42.0 - 14.0 * intensity) / 255.0),
                                          CIVector(x: 105.0 / 255.0, y: (105.0 - 5.0 * intensity) / 255.0),
                                          CIVector(x: 148.0 / 255.0, y: (148.0 + 12.0 * intensity) / 255.0),
                                          CIVector(x: 185.0 / 255.0, y: (185.0 + 23.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 40.0 / 255.0, y: (40.0 - 15.0 * intensity) / 255.0),
                                             CIVector(x: 85.0 / 255.0, y: (85.0 - 10.0 * intensity) / 255.0),
                                             CIVector(x: 125.0 / 255.0, y: (125.0 + 5.0 * intensity) / 255.0),
                                             CIVector(x: 165.0 / 255.0, y: (165.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 212.0 / 255.0, y: (212.0 + 18.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 40.0 / 255.0, y: (40.0 + 18.0 * intensity) / 255.0),
                                            CIVector(x: 82.0 / 255.0, y: (82.0 + 8.0 * intensity) / 255.0),
                                            CIVector(x: 125.0 / 255.0, y: 125.0 / 255.0),
                                            CIVector(x: 170.0 / 255.0, y: (170.0 + 10.0 * intensity) / 255.0),
                                            CIVector(x: 235.0 / 255.0, y: (210.0 + 25.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 33.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func sierraFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 48.0 / 255.0, y: (48.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 105.0 / 255.0, y: (105.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 130.0 / 255.0, y: (130.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 190.0 / 255.0, y: (190.0 + 22.0 * intensity) / 255.0),
                                          CIVector(x: 232.0 / 255.0, y: (232.0 + 2.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 10.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 38.0 / 255.0, y: (38.0 + 34.0 * intensity) / 255.0),
                                             CIVector(x: 85.0 / 255.0, y: (85.0 + 39.0 * intensity) / 255.0),
                                             CIVector(x: 124.0 / 255.0, y: (124.0 + 36.0 * intensity) / 255.0),
                                             CIVector(x: 172.0 / 255.0, y: (172.0 + 14.0 * intensity) / 255.0),
                                             CIVector(x: 218.0 / 255.0, y: (218.0 - 8.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 25.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 45.0 / 255.0, y: (45.0 + 37.0 * intensity) / 255.0),
                                            CIVector(x: 95.0 / 255.0, y: (95.0 + 87.0 * intensity) / 255.0),
                                            CIVector(x: 138.0 / 255.0, y: (138.0 + 26.0 * intensity) / 255.0),
                                            CIVector(x: 176.0 / 255.0, y: (176.0 + 6.0 * intensity) / 255.0),
                                            CIVector(x: 210.0 / 255.0, y: (210.0 - 10.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 37.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func willowFilter(intensity: CGFloat) -> [CIFilter]
    {
        guard let firstFilter = CIFilter(name: "CIPhotoEffectTonal") else { return [] }
        
        guard let secondFilter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 68.0 / 255.0, y: (68.0 + 37.0 * intensity) / 255.0),
                                          CIVector(x: 95.0 / 255.0, y: (95.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 175.0 / 255.0, y: (175.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 10.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 55.0 / 255.0, y: (55.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 105.0 / 255.0, y: (105.0 + 55.0 * intensity) / 255.0),
                                             CIVector(x: 198.0 / 255.0, y: (198.0 + 12.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 15.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 40.0 / 255.0, y: (40.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 112.0 / 255.0, y: (112.0 + 53.0 * intensity) / 255.0),
                                            CIVector(x: 195.0 / 255.0, y: (195.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
            else
        {
            return []
        }
        
        return [firstFilter, secondFilter]
        
    }
    
    class func loFiFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 40.0 / 255.0, y: (40.0 - 20.0 * intensity) / 255.0),
                                          CIVector(x: 88.0 / 255.0, y: (88.0 - 8.0 * intensity) / 255.0),
                                          CIVector(x: 128.0 / 255.0, y: (128.0 + 22.0 * intensity) / 255.0),
                                          CIVector(x: 170.0 / 255.0, y: (170.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 230.0 / 255.0, y: (230.0 + 15.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 35.0 / 255.0, y: (35.0 - 20.0 * intensity) / 255.0),
                                             CIVector(x: 90.0 / 255.0, y: (90.0 - 20.0 * intensity) / 255.0),
                                             CIVector(x: 105.0 / 255.0, y: 105.0 / 255.0),
                                             CIVector(x: 148.0 / 255.0, y: (148.0 + 32.0 * intensity) / 255.0),
                                             CIVector(x: 188.0 / 255.0, y: (188.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 62.0 / 255.0, y: (62.0 - 12.0 * intensity) / 255.0),
                                            CIVector(x: 100.0 / 255.0, y: (100.0 - 5.0 * intensity) / 255.0),
                                            CIVector(x: 130.0 / 255.0, y: (130.0 + 25.0 * intensity) / 255.0),
                                            CIVector(x: 150.0 / 255.0, y: (150.0 + 32.0 * intensity) / 255.0),
                                            CIVector(x: 190.0 / 255.0, y: (190.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func earlyBirdFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 25.0 * intensity) / 255.0),
                                          CIVector(x: 45.0 / 255.0, y: (45.0 + 35.0 * intensity) / 255.0),
                                          CIVector(x: 85.0 / 255.0, y: (85.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 120.0 / 255.0, y: (120.0 + 60.0 * intensity) / 255.0),
                                          CIVector(x: 230.0 / 255.0, y: (230.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 40.0 / 255.0, y: (40.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 88.0 / 255.0, y: (88.0 + 24.0 * intensity) / 255.0),
                                             CIVector(x: 132.0 / 255.0, y: (132.0 + 40.0 * intensity) / 255.0),
                                             CIVector(x: 168.0 / 255.0, y: (168.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 215.0 / 255.0, y: (215.0 + 3.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 15.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 18.0 * intensity) / 255.0),
                                            CIVector(x: 42.0 / 255.0, y: (42.0 + 16.0 * intensity) / 255.0),
                                            CIVector(x: 90.0 / 255.0, y: (90.0 + 12.0 * intensity) / 255.0),
                                            CIVector(x: 120.0 / 255.0, y: (120.0 + 10.0 * intensity) / 255.0),
                                            CIVector(x: 164.0 / 255.0, y: (164.0 + 6.0 * intensity) / 255.0),
                                            CIVector(x: 212.0 / 255.0, y: (212.0 - 17.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 45.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func sutroFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 40.0 / 255.0, y: (40.0 - 5.0 * intensity) / 255.0),
                                          CIVector(x: 90.0 / 255.0, y: (90.0 + 2.0 * intensity) / 255.0),
                                          CIVector(x: 145.0 / 255.0, y: (145.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 235.0 / 255.0, y: (235.0 - 5.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 20.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 60.0 / 255.0, y: (60.0 - 10.0 * intensity) / 255.0),
                                             CIVector(x: 155.0 / 255.0, y: (155.0 - 15.0 * intensity) / 255.0),
                                             CIVector(x: 210.0 / 255.0, y: (210.0 - 22.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 30.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 80.0 / 255.0, y: 80.0 / 255.0),
                                            CIVector(x: 128.0 / 255.0, y: (128.0 - 16.0 * intensity) / 255.0),
                                            CIVector(x: 182.0 / 255.0, y: (182.0 - 37.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 35.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func toasterFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 120.0 * intensity) / 255.0),
                                          CIVector(x: 50.0 / 255.0, y: (50.0 + 110.0 * intensity) / 255.0),
                                          CIVector(x: 105.0 / 255.0, y: (105.0 + 93.0 * intensity) / 255.0),
                                          CIVector(x: 145.0 / 255.0, y: (145.0 + 70.0 * intensity) / 255.0),
                                          CIVector(x: 190.0 / 255.0, y: (190.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 22.0 / 255.0, y: (22.0 - 38.0 * intensity) / 255.0),
                                             CIVector(x: 125.0 / 255.0, y: (125.0 + 55.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 50.0 * intensity) / 255.0),
                                            CIVector(x: 40.0 / 255.0, y: (40.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 80.0 / 255.0, y: (80.0 + 22.0 * intensity) / 255.0),
                                            CIVector(x: 122.0 / 255.0, y: (122.0 + 26.0 * intensity) / 255.0),
                                            CIVector(x: 185.0 / 255.0, y: 185.0 / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 45.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func brannanFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 35.0 * intensity) / 255.0),
                                          CIVector(x: 40.0 / 255.0, y: (40.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 125.0 / 255.0, y: (125.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 175.0 / 255.0, y: (175.0 + 55.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 65.0 / 255.0, y: (65.0 - 10.0 * intensity) / 255.0),
                                             CIVector(x: 92.0 / 255.0, y: (92.0 + 10.0 * intensity) / 255.0),
                                             CIVector(x: 180.0 / 255.0, y: (180.0 + 40.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 35.0 * intensity) / 255.0),
                                            CIVector(x: 62.0 / 255.0, y: 62.0 / 255.0),
                                            CIVector(x: 88.0 / 255.0, y: (88.0 + 7.0 * intensity) / 255.0),
                                            CIVector(x: 132.0 / 255.0, y: (132.0 + 26.0 * intensity) / 255.0),
                                            CIVector(x: 225.0 / 255.0, y: (225.0 + 5.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 23.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func walderFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 12.0 * intensity) / 255.0),
                                          CIVector(x: 40.0 / 255.0, y: (40.0 + 4.0 * intensity) / 255.0),
                                          CIVector(x: 85.0 / 255.0, y: (85.0 + 40.0 * intensity) / 255.0),
                                          CIVector(x: 122.0 / 255.0, y: (122.0 + 58.0 * intensity) / 255.0),
                                          CIVector(x: 170.0 / 255.0, y: (170.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 35.0 * intensity) / 255.0),
                                             CIVector(x: 40.0 / 255.0, y: (40.0 + 38.0 * intensity) / 255.0),
                                             CIVector(x: 90.0 / 255.0, y: (90.0 + 50.0 * intensity) / 255.0),
                                             CIVector(x: 130.0 / 255.0, y: (130.0 + 58.0 * intensity) / 255.0),
                                             CIVector(x: 175.0 / 255.0, y: (175.0 + 50.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 10.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 85.0 * intensity) / 255.0),
                                            CIVector(x: 85.0 / 255.0, y: (85.0 + 65.0 * intensity) / 255.0),
                                            CIVector(x: 130.0 / 255.0, y: (130.0 + 40.0 * intensity) / 255.0),
                                            CIVector(x: 165.0 / 255.0, y: (165.0 + 20.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 35.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func hefeFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 60.0 / 255.0, y: (60.0 - 5.0 * intensity) / 255.0),
                                          CIVector(x: 130.0 / 255.0, y: (130.0 + 25.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 65.0 / 255.0, y: (65.0 - 25.0 * intensity) / 255.0),
                                             CIVector(x: 125.0 / 255.0, y: 125.0 / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 65.0 / 255.0, y: (65.0 - 35.0 * intensity) / 255.0),
                                            CIVector(x: 125.0 / 255.0, y: (125.0 - 20.0 * intensity) / 255.0),
                                            CIVector(x: 170.0 / 255.0, y: (170.0 - 5.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 15.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func nashvilleFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 30.0 / 255.0, y: (30.0 - 25.0 * intensity) / 255.0),
                                          CIVector(x: 58.0 / 255.0, y: (58.0 - 33.0 * intensity) / 255.0),
                                          CIVector(x: 83.0 / 255.0, y: (83.0 + 2.0 * intensity) / 255.0),
                                          CIVector(x: 112.0 / 255.0, y: (112.0 + 28.0 * intensity) / 255.0),
                                          CIVector(x: 190.0 / 255.0, y: (190.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 20.0 / 255.0, y: (20.0 - 15.0 * intensity) / 255.0),
                                             CIVector(x: 50.0 / 255.0, y: (50.0 + 12.0 * intensity) / 255.0),
                                             CIVector(x: 132.0 / 255.0, y: (132 + 18.0 * intensity) / 255.0),
                                             CIVector(x: 190.0 / 255.0, y: (190.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 225.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 65.0 * intensity) / 255.0),
                                            CIVector(x: 40.0 / 255.0, y: (40.0 + 50.0 * intensity) / 255.0),
                                            CIVector(x: 85.0 / 255.0, y: (85.0 + 30.0 * intensity) / 255.0),
                                            CIVector(x: 212.0 / 255.0, y: (212.0 - 27.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 50.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func f1977Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 75.0 * intensity) / 255.0),
                                          CIVector(x: 75.0 / 255.0, y: (75.0 + 50.0 * intensity) / 255.0),
                                          CIVector(x: 145.0 / 255.0, y: (145.0 + 55.0 * intensity) / 255.0),
                                          CIVector(x: 190.0 / 255.0, y: (190.0 + 30.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 25.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 52.0 * intensity) / 255.0),
                                             CIVector(x: 42.0 / 255.0, y: (42.0 + 12.0 * intensity) / 255.0),
                                             CIVector(x: 110.0 / 255.0, y: (110.0 + 10.0 * intensity) / 255.0),
                                             CIVector(x: 154.0 / 255.0, y: (154 + 14.0 * intensity) / 255.0),
                                             CIVector(x: 232.0 / 255.0, y: (232.0 + 2.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 13.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 62.0 * intensity) / 255.0),
                                            CIVector(x: 65.0 / 255.0, y: (65.0 + 17.0 * intensity) / 255.0),
                                            CIVector(x: 108.0 / 255.0, y: (108 + 24.0 * intensity) / 255.0),
                                            CIVector(x: 175.0 / 255.0, y: (175.0 + 35.0 * intensity) / 255.0),
                                            CIVector(x: 210.0 / 255.0, y: (210.0 - 2.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 47 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func kelvinFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 60.0 / 255.0, y: (60.0 + 42.0 * intensity) / 255.0),
                                          CIVector(x: 110.0 / 255.0, y: (110.0 + 75.0 * intensity) / 255.0),
                                          CIVector(x: 150.0 / 255.0, y: (150.0 + 70.0 * intensity) / 255.0),
                                          CIVector(x: 235.0 / 255.0, y: (235.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 10.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 68.0 / 255.0, y: 68.0 / 255.0),
                                             CIVector(x: 105.0 / 255.0, y: (105.0 + 15.0 * intensity) / 255.0),
                                             CIVector(x: 190.0 / 255.0, y: (190.0 + 30.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 88.0 / 255.0, y: (88.0 - 76.0 * intensity) / 255.0),
                                            CIVector(x: 145.0 / 255.0, y: (145.0 - 5.0 * intensity) / 255.0),
                                            CIVector(x: 185.0 / 255.0, y: (185.0 + 27.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func fadeFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIPhotoEffectFade")
        {
            return [filter]
        }
        
        return []
    }
    
    class func instantFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIPhotoEffectInstant")
        {
            return [filter]
        }
        
        return []
    }
    
    class func comicEffectFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIComicEffect")
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare1Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 68.0 / 255.0, y: (68.0 + 41.0 * intensity) / 255.0),
                                          CIVector(x: 139.0 / 255.0, y: (139.0 + 28.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 105.0 / 255.0, y: (105.0 - 7.0 * intensity) / 255.0),
                                             CIVector(x: 152.0 / 255.0, y: (152.0 + 21.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare2Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 74.0 / 255.0, y: (74.0 + 52.0 * intensity) / 255.0),
                                          CIVector(x: 188.0 / 255.0, y: (188.0 - 30.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 89.0 / 255.0, y: (89.0 + 2.0 * intensity) / 255.0),
                                             CIVector(x: 152.0 / 255.0, y: (152.0 + 46.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 53.0 / 255.0, y: (53.0 + 54.0 * intensity) / 255.0),
                                            CIVector(x: 106.0 / 255.0, y: (106.0 + 53.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare3Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 97.0 / 255.0, y: (97.0 - 20.0 * intensity) / 255.0),
                                          CIVector(x: 197.0 / 255.0, y: (197.0 - 61.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 74.0 / 255.0, y: (74.0 + 25.0 * intensity) / 255.0),
                                             CIVector(x: 161.0 / 255.0, y: (161.0 - 2.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 96.0 / 255.0, y: (96.0 - 44.0 * intensity) / 255.0),
                                            CIVector(x: 194.0 / 255.0, y: (194.0 - 26.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare4Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 119.0 / 255.0, y: (119.0 + 22.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 107.0 / 255.0, y: (107 + 5.0 * intensity) / 255.0),
                                             CIVector(x: 164.0 / 255.0, y: (164.0 + 36.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 67.0 / 255.0, y: (67.0 + 50.0 * intensity) / 255.0),
                                            CIVector(x: 177.0 / 255.0, y: (177.0 - 8.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare5Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 164.0 / 255.0, y: (164.0 + 21.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 73.0 / 255.0, y: (73.0 + 23.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 107.0 / 255.0, y: (107.0 + 51.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare6Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 90.0 / 255.0, y: (90.0 - 23.0 * intensity) / 255.0),
                                          CIVector(x: 112.0 / 255.0, y: (112.0 + 34.0 * intensity) / 255.0),
                                          CIVector(x: 171.0 / 255.0, y: (171.0 + 39.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 112.0 / 255.0, y: (112.0 + 2.0 * intensity) / 255.0),
                                             CIVector(x: 119.0 / 255.0, y: (119.0 + 68.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 111.0 / 255.0, y: (111.0 - 4.0 * intensity) / 255.0),
                                            CIVector(x: 155.0 / 255.0, y: (155.0 + 32.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare7Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 62.0 / 255.0, y: (62.0 + 25.0 * intensity) / 255.0),
                                          CIVector(x: 164.0 / 255.0, y: (164.0 + 35.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 76.0 / 255.0, y: (76.0 + 25.0 * intensity) / 255.0),
                                             CIVector(x: 129.0 / 255.0, y: (129.0 + 32.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 51.0 / 255.0, y: (51.0 + 61.0 * intensity) / 255.0),
                                            CIVector(x: 169.0 / 255.0, y: (169.0 + 41.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare8Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 84.0 / 255.0, y: (84.0 + 10.0 * intensity) / 255.0),
                                          CIVector(x: 140.0 / 255.0, y: (140.0 + 12.0 * intensity) / 255.0),
                                          CIVector(x: 215.0 / 255.0, y: (215.0 - 45.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 83.0 / 255.0, y: (83.0 - 13.0 * intensity) / 255.0),
                                             CIVector(x: 147.0 / 255.0, y: (147 - 9.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 75.0 / 255.0, y: (75.0 + 12.0 * intensity) / 255.0),
                                            CIVector(x: 119.0 / 255.0, y: (119.0 + 3.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare9Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 58.0 * intensity) / 255.0),
                                          CIVector(x: 89.0 / 255.0, y: (89.0 + 11.0 * intensity) / 255.0),
                                          CIVector(x: 179.0 / 255.0, y: (179.0 + 20.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: (255.0 - 34.0 * intensity) / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 58.0 * intensity) / 255.0),
                                             CIVector(x: 150.0 / 255.0, y: 150.0 / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 77.0 * intensity) / 255.0),
                                            CIVector(x: 129.0 / 255.0, y: (129.0 + 19.0 * intensity) / 255.0),
                                            CIVector(x: 175.0 / 255.0, y: (175.0 + 24.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare10Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 23.0 * intensity) / 255.0),
                                          CIVector(x: 153.0 / 255.0, y: (153.0 - 32.0 * intensity) / 255.0),
                                          CIVector(x: 206.0 / 255.0, y: (206.0 - 7.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 65.0 * intensity) / 255.0),
                                             CIVector(x: 128.0 / 255.0, y: (128.0 - 8.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 39.0 * intensity) / 255.0),
                                            CIVector(x: 125.0 / 255.0, y: (125.0 + 37.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 19.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare11Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 154.0 / 255.0, y: (154.0 - 25.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 46.0 * intensity) / 255.0),
                                             CIVector(x: 154.0 / 255.0, y: (154.0 - 26.0 * intensity) / 255.0),
                                             CIVector(x: 167.0 / 255.0, y: (167.0 - 18.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 74.0 * intensity) / 255.0),
                                            CIVector(x: 133.0 / 255.0, y: (133.0 + 16.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 40.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare12Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 41.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 62.0 * intensity) / 255.0),
                                             CIVector(x: 121.0 / 255.0, y: (121.0 + 64.0 * intensity) / 255.0),
                                             CIVector(x: 188.0 / 255.0, y: (188.0 + 60.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 55.0 * intensity) / 255.0),
                                            CIVector(x: 92.0 / 255.0, y: (92.0 + 88.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: (255.0 - 47.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare13Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: (0.0 + 79.0 * intensity) / 255.0),
                                          CIVector(x: 127.0 / 255.0, y: (127.0 + 8.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 82.0 * intensity) / 255.0),
                                             CIVector(x: 124.0 / 255.0, y: (124.0 - 1.0 * intensity) / 255.0),
                                             CIVector(x: 231.0 / 255.0, y: (231.0 + 24.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: (0.0 + 95.0 * intensity) / 255.0),
                                            CIVector(x: 139.0 / 255.0, y: (139.0 - 17.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare14Filter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 36.0 / 255.0, y: (36.0 - 36.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 28.0 / 255.0, y: (28.0 - 28.0 * intensity) / 255.0),
                                             CIVector(x: 123.0 / 255.0, y: (123.0 + 10.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: (255.0 - 65.0 * intensity) / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 54.0 / 255.0, y: (54.0 - 54.0 * intensity) / 255.0),
                                            CIVector(x: 73.0 / 255.0, y: (73.0 + 40.0 * intensity) / 255.0),
                                            CIVector(x: 150.0 / 255.0, y: 150.0 / 255.0),
                                            CIVector(x: 254.0 / 255.0, y: (254.0 + 45.0 * intensity) / 255.0)]
            ])
        {
            return [filter]
        }
        
        return []
    }
    
    class func mare15Filter(intensity: CGFloat) -> [CIFilter] //NIJE DOBRO
    {
        guard let firstFilter = CIFilter(name: "CIColorControls") else { return [] }
        firstFilter.setValue(0.4, forKey: kCIInputSaturationKey)
        
        guard let secondFilter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 93.0 / 255.0, y: (93.0 + 32.0 * intensity) / 255.0),
                                          CIVector(x: 168.0 / 255.0, y: (168.0 + 14.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 89.0 / 255.0, y: (89.0 - 29.0 * intensity) / 255.0),
                                             CIVector(x: 156.0 / 255.0, y: (156.0 + 14.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 42.0 / 255.0, y: (42.0 + 51.0 * intensity) / 255.0),
                                            CIVector(x: 151.0 / 255.0, y: (151.0 + 28.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
            else
        {
            return []
        }
        
        return [secondFilter, firstFilter]
    }
    
    class func mare16Filter(intensity: CGFloat) -> [CIFilter] //NIJE DOBRO
    {
        guard let firstFilter = CIFilter(name: "CIColorControls") else { return [] }
        firstFilter.setValue(0.25, forKey: kCIInputSaturationKey)
        
        guard let secondFilter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 133.0 / 255.0, y: (133.0 - 25.0 * intensity) / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 96.0 / 255.0, y: (96.0 + 35.0 * intensity) / 255.0),
                                             CIVector(x: 174.0 / 255.0, y: (174.0 + 19.0 * intensity) / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 89.0 / 255.0, y: (89.0 - 32.0 * intensity) / 255.0),
                                            CIVector(x: 137.0 / 255.0, y: (137.0 + 42.0 * intensity) / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
            else
        {
            return []
        }
        
        return [secondFilter, firstFilter]
    }
    
    
    class func mare21Filter() -> [CIFilter]
    {
        guard let firstFilter = CIFilter(name: "CIColorControls") else { return [] }
        firstFilter.setValue(0.25, forKey: kCIInputSaturationKey)
        
        guard let secondFilter = CIFilter(
            name: "YUCIRGBToneCurve",
            withInputParameters:[
                "inputRedControlPoints": [CIVector(x: 0.0 / 255.0, y: 0.0 / 255.0),
                                          CIVector(x: 100.0 / 255.0, y: 50.0 / 255.0),
                                          CIVector(x: 167.0 / 255.0, y: 169.0 / 255.0),
                                          CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputGreenControlPoints" : [CIVector(x: 21.0 / 255.0, y: 0.0 / 255.0),
                                             CIVector(x: 73.0 / 255.0, y: 76.0 / 255.0),
                                             CIVector(x: 161.0 / 255.0, y: 158.0 / 255.0),
                                             CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)],
                
                "inputBlueControlPoints" : [CIVector(x: 9.0 / 255.0, y: 0.0 / 255.0),
                                            CIVector(x: 76.0 / 255.0, y: 92.0 / 255.0),
                                            CIVector(x: 193.0 / 255.0, y: 168.0 / 255.0),
                                            CIVector(x: 255.0 / 255.0, y: 255.0 / 255.0)]
            ])
            else
        {
            return []
        }
        
        return [secondFilter, firstFilter]
    }
    
    class func minimumComponentFilter() -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIMinimumComponent")
        {
            return [filter]
        }
        
        return []
    }
    
    class func maximumComponentFilter() -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIMaximumComponent")
        {
            return [filter]
        }
        return []
    }
    
    class func blackAndWhiteFilter(intensity: CGFloat) -> [CIFilter]
    {
        if let filter = CIFilter(name: "CIColorControls")
        {
            filter.setValue(1.0 - 1.0 * intensity, forKey: kCIInputSaturationKey)
            return [filter]
        }
        
        return []
    }
}
