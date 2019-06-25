//
//  EditorImageView.swift
//  Memories
//
//  Created by Ilija Antonjevic on 16/01/2019.
//  Copyright © 2019 Ilija Antonijevic. All rights reserved.
//

import UIKit

class EditorImageView: UIImageView
{
    var hasAutoAlign = true
    var hasRotate = true
    var hasScale = true
    var minimumScaleFactor: CGFloat?
    var isClearTouchEnabled = false
    var hasAutoTranslate = true
    var maximumScaleFactor: CGFloat = 2.0
    
    init()
    {
        super.init(frame: CGRect.zero)
        customInit()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        customInit()
    }
    
    override init(image: UIImage?)
    {
        super.init(image: image)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        customInit()
    }
    
    func customInit()
    {
        self.isMultipleTouchEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        if isClearTouchEnabled
        {
            return super.point(inside: point, with: event)
        }
        
        //        if let color = self.color(of: point)
        //        {
        //            let alpha = color.cgColor.alpha
        //            return alpha > 0
        //        }
        
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "bounds"
        {
            superviewBoundsChanged()
        }
    }
    
    private var superviewSize = CGSize.zero
    override func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        superviewSize = self.superview?.bounds.size ?? CGSize.zero
        self.superview?.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func removeFromSuperview()
    {
        self.superview?.removeObserver(self, forKeyPath: "bounds")
        super.removeFromSuperview()
    }
    
    private var _firstTouch: UITouch?
    private var _secondTouch: UITouch?
    
    private var _deltaAngle: CGFloat?
    private var _prevDistance: CGFloat?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        NotificationCenter.default.post(name: .imageEditingBegan, object: self)
        //set first touch
        if let _event = event, let _touches = _event.touches(for: self)
        {
            if _firstTouch == nil
            {
                _firstTouch = _touches.first
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
        
        if let _event = event, let _touches = _event.touches(for: self)
        {
            var hasFirstTouch = false
            
            if _firstTouch != nil
            {
                for touch in _touches
                {
                    if touch == _firstTouch
                    {
                        hasFirstTouch = true
                        break
                    }
                }
            }
            
            if !hasFirstTouch
            {
                _firstTouch = _touches.first
            }
            
            if _touches.count > 1
            {
                var hasSecondTouch = false
                
                if _secondTouch != nil
                {
                    for touch in _touches
                    {
                        if touch == _secondTouch
                        {
                            hasSecondTouch = true
                            break
                        }
                    }
                }
                
                if !hasSecondTouch
                {
                    for touch in _touches
                    {
                        if touch != _firstTouch
                        {
                            _secondTouch = touch
                            break
                        }
                    }
                }
            }
            else
            {
                _secondTouch = nil
                _prevDistance = nil
                _deltaAngle = nil
            }
        }
        
        if let first = self._firstTouch
        {
            let translation = moveTransform(touch: first)
            var _transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeTranslation(translation.x, translation.y, 0.0))
            
            if let second = self._secondTouch
            {
                if self.hasRotate
                {
                    _transform = CATransform3DConcat(_transform, CATransform3DMakeRotation(rotateTransform(firstTouch: first, secondTouch: second), 0.0, 0.0, 1.0))
                }
                if self.hasScale
                {
                    let scale = scaleTransform(firstTouch: first, secondTouch: second)
                    
                    if let currentScale = self.layer.value(forKeyPath: "transform.scale") as? CGFloat
                    {
                        if currentScale >= maximumScaleFactor && scale > 1.0
                        {
                            return
                        }
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name("editorImageViewTransformed"), object: scale)
                    
                    
                    _transform = CATransform3DConcat(_transform, CATransform3DMakeScale(scale, scale, 1.0))
                }
            }
            
            self.layer.transform = _transform
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        
        if let _event = event, let _touches = _event.touches(for: self)
        {
            if touches.count == _touches.count
            {
                if self.hasAutoAlign
                {
                    self.align(animated: true)
                }
                else if let minimumScale = self.minimumScaleFactor
                {
                    self.fixMinimumScale(scale: minimumScale)
                }
                
                NotificationCenter.default.post(name: .imageEditingEnded, object: self.layer.transform)
            }
        }
        
        _firstTouch = nil
        _secondTouch = nil
        
        _prevDistance = nil
        _deltaAngle = nil
    }
    
    //MARK: Transforms
    
    private func moveTransform(touch: UITouch)-> CGPoint
    {
        let translation = CGPoint(x: touch.location(in: self.superview!).x - touch.previousLocation(in: self.superview!).x, y: touch.location(in: self.superview!).y - touch.previousLocation(in: self.superview!).y)
        return CGPoint(x: translation.x, y: translation.y)
    }
    
    private func scaleTransform(firstTouch: UITouch, secondTouch: UITouch)-> CGFloat
    {
        let firstPoint = firstTouch.location(in: self)
        let secondPoint = secondTouch.location(in: self)
        
        if _prevDistance == nil
        {
            _prevDistance = getDistance(firstPoint: firstPoint, secondPoint: secondPoint)
        }
        
        let newDistance = getDistance(firstPoint: firstPoint, secondPoint: secondPoint)
        let scale = newDistance / _prevDistance!
        
        return scale
    }
    
    private func getDistance(firstPoint: CGPoint, secondPoint: CGPoint)-> CGFloat
    {
        let squareX = (secondPoint.x - firstPoint.x) * (secondPoint.x - firstPoint.x)
        let squareY = (secondPoint.y - firstPoint.y) * (secondPoint.y - firstPoint.y)
        let distance = sqrt(squareX + squareY)
        
        return distance
    }
    
    private func rotateTransform(firstTouch: UITouch, secondTouch: UITouch)-> CGFloat
    {
        let firstPoint = firstTouch.location(in: self)
        let secondPoint = secondTouch.location(in: self)
        
        let angleX = atan2(secondPoint.y - firstPoint.y,secondPoint.x - firstPoint.x)
        
        if _deltaAngle == nil
        {
            _deltaAngle = angleX
        }
        
        let angleDiff = _deltaAngle! - angleX
        return -angleDiff
    }
    
    //MARK: Alignment
    
    func initialPosition()
    {
        self.layer.transform = CATransform3DIdentity
        if let image = self.image
        {
            var height: CGFloat = 0.0
            var width: CGFloat = 0.0
            
            if hasAutoAlign
            {
                width = max(superviewSize.height * image.size.width / image.size.height, superviewSize.width)
                height = width * image.size.height / image.size.width
            }
            else
            {
                width = min(superviewSize.height * image.size.width / image.size.height, superviewSize.width)
                height = width * image.size.height / image.size.width
            }
            
            self.frame = CGRect(x: (superviewSize.width - width) / 2.0, y: (superviewSize.height - height) / 2.0, width: width, height: height)
        }
    }
    
    func initalPositionAnimated()
    {
        UIView.animate(withDuration: 0.2) {
            self.initialPosition()
        }
    }
    
    func align(animated: Bool)
    {
        guard let fixTransformations = fixTransformations() else { return }
        
        var newTransform = CATransform3DConcat(self.layer.transform, CATransform3DMakeScale(fixTransformations.scale, fixTransformations.scale, 1.0))
        newTransform = CATransform3DConcat(newTransform, CATransform3DMakeTranslation(fixTransformations.translate.x, fixTransformations.translate.y, 0.0))
        
        NotificationCenter.default.post(name: NSNotification.Name("editorImageViewTransformed"), object: fixTransformations.scale)
        
        if animated
        {
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: self.layer.transform)
            animation.toValue = NSValue(caTransform3D: newTransform)
            animation.duration = 0.3
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = true
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.layer.add(animation, forKey: nil)
            self.layer.transform = newTransform
        }
        else
        {
            self.layer.transform = newTransform
        }
    }
    
    private func alignWithoutTranslation(animated: Bool)
    {
        guard let scaleTransform = fixScaleTransformation() else { return }
        
        let newTransform = CATransform3DConcat(self.layer.transform, CATransform3DMakeScale(scaleTransform, scaleTransform, 1.0))
        
        if animated
        {
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: self.layer.transform)
            animation.toValue = NSValue(caTransform3D: newTransform)
            animation.duration = 0.3
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = true
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.layer.add(animation, forKey: nil)
            self.layer.transform = newTransform
        }
        else
        {
            self.layer.transform = newTransform
        }
    }
    
    private func superviewBoundsChanged()
    {
        let oldSize = superviewSize
        superviewSize = self.superview?.bounds.size ?? CGSize.zero
        
        //print("size: \(oldSize)")
        if oldSize != superviewSize
        {
            //print("realign")
            if hasAutoTranslate
            {
                realign()
            }
            else
            {
                realignWithoutTranslation(animated: true)
            }
        }
    }
    
    func realign()
    {
        let transform = self.layer.transform
        self.initialPosition()
        self.layer.transform = transform
        if self.hasAutoAlign
        {
            self.align(animated: true)
        }
    }
    
    func realignWithoutTranslation(animated: Bool)
    {
        let transform = self.layer.transform
        self.initialPosition()
        self.layer.transform = transform
        if self.hasAutoAlign
        {
            self.alignWithoutTranslation(animated: animated)
        }
    }
    
    private func fixTransformations()-> (translate: CGPoint, scale: CGFloat)?
    {
        var scale:CGFloat = 1.0
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let rotationAngle =  self.value(forKeyPath: "layer.transform.rotation.z") as! CGFloat
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(-rotationAngle, 0.0, 0.0, 1.0))
        let photoFrame = self.frame
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0))
        
        guard let superviewSize = superview?.frame.size else {return nil}
        
        //scale
        let minimumWidth = fabs(cos(rotationAngle)) * superviewSize.width + fabs(sin(rotationAngle)) * superviewSize.height
        let minimumHeight = fabs(sin(rotationAngle)) * superviewSize.width + fabs(cos(rotationAngle)) * superviewSize.height
        
        if photoFrame.size.width / minimumWidth < 1 || photoFrame.size.height / minimumHeight < 1
        {
            let scaleW = minimumWidth / photoFrame.size.width
            let scaleH = minimumHeight / photoFrame.size.height
            
            scale = max(scaleW, scaleH)
        }
        
        //translation
        let superViewCenter = CGPoint(x: superviewSize.width / 2, y: superviewSize.height / 2)
        
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeScale(scale, scale, 1.0))
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(-rotationAngle, 0.0, 0.0, 1.0))
        let scaledFrame = self.frame
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0))
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeScale(1/scale, 1/scale, 1.0))
        
        let photoCenter = CGPoint(x: scaledFrame.origin.x + scaledFrame.width / 2,y: scaledFrame.origin.y + scaledFrame.height / 2)
        
        let maxXOffset = (scaledFrame.width - minimumWidth) / 2
        let maxYOffset = (scaledFrame.height - minimumHeight) /  2
        
        var proposedTranslation = CGPoint.zero
        if photoCenter.x > superViewCenter.x + maxXOffset
        {
            proposedTranslation.x = superViewCenter.x + maxXOffset - photoCenter.x
        }
        else if photoCenter.x < superViewCenter.x - maxXOffset
        {
            proposedTranslation.x = superViewCenter.x - maxXOffset - photoCenter.x
        }
        
        if photoCenter.y > superViewCenter.y + maxYOffset
        {
            proposedTranslation.y = superViewCenter.y + maxYOffset - photoCenter.y
        }
        else if photoCenter.y < superViewCenter.y - maxYOffset
        {
            proposedTranslation.y = superViewCenter.y - maxYOffset - photoCenter.y
        }
        
        var translation = CGPoint.zero
        translation.y = proposedTranslation.y * cos(rotationAngle) + proposedTranslation.x * sin(rotationAngle)
        translation.x = proposedTranslation.x * cos(-rotationAngle) + proposedTranslation.y * sin(-rotationAngle)
        
        CATransaction.commit()
        
        return (translate: CGPoint(x: translation.x, y: translation.y), scale: scale)
    }
    
    func fixScaleTransformation() -> CGFloat?
    {
        var scale:CGFloat = 1.0
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let rotationAngle =  self.value(forKeyPath: "layer.transform.rotation.z") as! CGFloat
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(-rotationAngle, 0.0, 0.0, 1.0))
        let photoFrame = self.frame
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0))
        
        guard let superviewSize = superview?.frame.size else {return nil}
        
        //scale
        let minimumWidth = fabs(cos(rotationAngle)) * superviewSize.width + fabs(sin(rotationAngle)) * superviewSize.height
        let minimumHeight = fabs(sin(rotationAngle)) * superviewSize.width + fabs(cos(rotationAngle)) * superviewSize.height
        
        if photoFrame.size.width / minimumWidth < 1 || photoFrame.size.height / minimumHeight < 1
        {
            let scaleW = minimumWidth / photoFrame.size.width
            let scaleH = minimumHeight / photoFrame.size.height
            
            scale = max(scaleW, scaleH)
        }
        
        CATransaction.commit()
        
        return scale
    }
    
    private func fixMinimumScale(scale: CGFloat)
    {
        var fixedScale:CGFloat = 1.0
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let rotationAngle =  self.value(forKeyPath: "layer.transform.rotation.z") as! CGFloat
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(-rotationAngle, 0.0, 0.0, 1.0))
        let photoFrame = self.frame
        self.layer.transform = CATransform3DConcat(self.layer.transform, CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0))
        
        guard let superviewSize = superview?.frame.size else {return}
        
        var minimumWidth = scale * superviewSize.width
        if superviewSize.width * 2 < superviewSize.height
        {
            minimumWidth = superviewSize.width
        }
        var minimumHeight = scale * superviewSize.height
        if superviewSize.height * 2 < superviewSize.width
        {
            minimumHeight = superviewSize.height
        }
        
        if minimumWidth / photoFrame.size.width > 1 || minimumHeight / photoFrame.size.height > 1
        {
            let scaleW = minimumWidth / photoFrame.size.width
            let scaleH = minimumHeight / photoFrame.size.height
            
            fixedScale = max(scaleW, scaleH)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("editorImageViewTransformed"), object: fixedScale)
        
        CATransaction.commit()
        
        let newTransform = CATransform3DConcat(self.layer.transform, CATransform3DMakeScale(fixedScale, fixedScale, 1.0))
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: self.layer.transform)
        animation.toValue = NSValue(caTransform3D: newTransform)
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.layer.add(animation, forKey: nil)
        self.layer.transform = newTransform
    }
}
