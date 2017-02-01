//
//  AnimationManager.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

protocol AnimationManagerDelegate: class {
    func managerDidFinishProgressAnimation(_ animation: CAAnimation, _ manager: AnimationManager)
}

class AnimationManager: NSObject {
    
    static var shared = AnimationManager()

    weak var managerDelegate: AnimationManagerDelegate?
    
    //MARK: - Variables
    
    internal lazy var strokeEndAnimation: CAAnimation = {
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
    
    internal lazy var strokeStartAnimation: CAAnimation = {
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
    
    internal lazy var fadeInAnimation: CAAnimation = {
    	let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.repeatCount = 1
        animation.duration = KVSpinnerViewSettings.fadeInDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }()
    
    internal lazy var fadeOutAnimation: CAAnimation = {
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
    
    //MARK: - Functions
    
    internal var downloadedProgress: CGFloat = 0.0

    internal func animateStrokeEnd(toValue value: CGFloat) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = downloadedProgress
        animation.toValue = value
        animation.repeatCount = 1
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        return animation
    }
}

extension AnimationManager: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        managerDelegate?.managerDidFinishProgressAnimation(anim, self)
    }
    
}







