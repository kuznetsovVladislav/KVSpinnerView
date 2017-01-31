//
//  AnimationManager.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

class AnimationManager: NSObject {
    
    public static var strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue =
        animation.duration = KVSpinnerViewSettings.animationDuration - 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = KVSpinnerViewSettings.animationDuration
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    public static var strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = KVSpinnerViewSettings.animationDuration - 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = KVSpinnerViewSettings.animationDuration
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    public static var fadeInAnimation: CAAnimation = {
    	let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.repeatCount = 1
        animation.duration = KVSpinnerViewSettings.fadeInDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }()
    
    public static var fadeOutAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.repeatCount = 1
        animation.duration = KVSpinnerViewSettings.fadeOutDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }()

}
