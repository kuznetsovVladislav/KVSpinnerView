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
        animation.toValue = 1
        animation.duration = KVSpinnerView.settings.animationDuration - 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = KVSpinnerView.settings.animationDuration
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    internal lazy var strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = KVSpinnerView.settings.animationDuration - 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = KVSpinnerView.settings.animationDuration
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    internal lazy var infiniteStrokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0.0
        animation.fromValue = 0.0
        animation.toValue = 0.4
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }()
    
    internal func infiniteStrokeRotateAnimation(isOdd: Bool) -> CAAnimation  {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
       	animation.byValue = isOdd ? M_PI * -2.0 : M_PI * 2.0
        
        let group = CAAnimationGroup()
        group.beginTime = 0.5
        group.duration = 1.5
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }
    
    internal lazy var fadeInAnimation: CAAnimation = {
    	let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.repeatCount = 1
        animation.duration = KVSpinnerView.settings.fadeInDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }()
    
    internal lazy var fadeOutAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.repeatCount = 1
        animation.duration = KVSpinnerView.settings.fadeOutDuration
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







