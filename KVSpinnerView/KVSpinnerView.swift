//
//  SpinningView.swift
//  CALayer
//
//  Created by Владислав  on 30.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

//MARK: - KVSpinnerView

public class KVSpinnerView: UIView {
    
    //MARK: - Public Static
    
    /**
    	You only should invoke shared instance to use any methods
    	of KVSpinnerView
 	*/
    public static var shared = KVSpinnerView()
    
    /**
    	Adds SpinnerView to UIWindow and start animating it
	*/
    public func show() {
        privateShow()
    }
    
    /**
    	Adds SpinnerView to your view and start animating it
    	- parameter view: use from ViewController (for example: self.view).
 	*/
    public func show(on view: UIView) {
        privateStartAnimating(on: view)
    }
    
    /**
    	Adds SpinnerView to UIWindow and start animating it with given progress
    	You should call it in
    	request progress closure (for example Alamofire .downloadProgress(_ progress))
    	- parameter progress: incoming progress
     */
    public func show(with progress: Progress) {
        privateShow()
        privateHandleProgress(progress)
    }
    
	/**
     	Adds SpinnerView to your view and start animating it
     	with message
     	- parameter status: message you want to display
 	*/
    public func show(saying status: String) {
        privateShow(withMessage: status)
    }
    
    /**
     	Adds SpinnerView to your view and start animating it
     	with message and progress
     	- parameter status: 	message you want to display
     	- parameter progress: 	incoming progress(use in request progress closure)
    */
    public func show(saying status: String, withProgress progress: Progress) {
        
    }
    
    /**
 		Removes SpinnerView from either UIWindow or ViewController's view
     	and stops all animations
 	*/
    public func dismiss() {
		privateDismiss()
    }
    
    /**
    	Removes SpinnerView from either UIWindow or ViewController's view
     	and stops all animations after 'interval' time.
     	- parameter interval: incoming progress(use in request progress closure)
 	*/
    public func dismiss(after interval: TimeInterval) {
        
    }
    
    //MARK: - Private variables
    
    fileprivate var isAnimating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    fileprivate var circleLayers = [CircleLayer]()
    fileprivate var rectangleLayer = RectangleLayer()
    fileprivate var progressLayer = ProgressLayer()
    
    fileprivate var progress: CGFloat = 0.0
    fileprivate var chosenView: UIView?
    
    //MARK: - Private methods
    
    fileprivate func setup() {
        
        /// Rectangle layer
        self.layer.addSublayer(rectangleLayer)
        
        /// Circle layers
        for index in 1 ... KVSpinnerViewSettings.linesCount {
            let circleLayer = CircleLayer(index: index)
            circleLayers.append(circleLayer)
            self.layer.addSublayer(circleLayer)
        }
        
    	/// Progress Layer
        //layer.addSublayer(progressLayer)
        
        setupLayersPositions()
        tintColorDidChange()
    }
    
    fileprivate func setupLayersPositions() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        for circleLayer in circleLayers {
            circleLayer.position = center 
        }
        rectangleLayer.position = center
    }
    
    fileprivate func updateAnimation() {
        if isAnimating == true {
            rectangleLayer.add(AnimationManager.fadeInAnimation, forKey: "rectangleFadeIn")
            for circleLayer in circleLayers {
                circleLayer.add(AnimationManager.fadeInAnimation, forKey: "circlesFadeIn")
                circleLayer.add(AnimationManager.strokeEndAnimation, forKey: "strokeEndAnimation")
                circleLayer.add(AnimationManager.strokeStartAnimation, forKey: "strokeStartAnimation")
            }
        }
        else {
            rectangleLayer.removeAnimation(forKey: "rectangleFadeIn")
            for circleLayer in circleLayers {
                circleLayer.removeAnimation(forKey: "circlesFadeIn")
                circleLayer.removeAnimation(forKey: "strokeEndAnimation")
                circleLayer.removeAnimation(forKey: "strokeStartAnimation")
            }
        }
    }
    
    //MARK: - Override

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        for circleLayer in circleLayers {
            circleLayer.strokeColor = KVSpinnerViewSettings.tintColor.cgColor
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupLayersPositions()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        fatalError("You have to use 'SpinningView.shared.show()' or 'SpinningView.shared.startAnimating(on view: _)' instead.\n")
    }
}

//MARK: - Private extension

fileprivate extension KVSpinnerView {
 
    fileprivate func privateStartAnimating(on view: UIView) {
        chosenView = view
        let radius = KVSpinnerViewSettings.spinnerRadius
        self.frame = CGRect(x: view.bounds.midX,
                            y: view.bounds.midY,
                            width: radius,
                            height: radius)
        
        self.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        isAnimating = true
        view.addSubview(self)
    }
    
    fileprivate func privateShow() {
        let window = UIApplication.shared.keyWindow!
        let radius = KVSpinnerViewSettings.spinnerRadius
        self.frame = CGRect(x: window.bounds.midX,
                            y: window.bounds.midY,
                            width: radius,
                            height: radius)
        self.center = CGPoint(x: window.bounds.midX, y: window.bounds.midY)
        isAnimating = true
        self.alpha = 1.0
        window.addSubview(self)
    }
    
    fileprivate func privateShow(withMessage message: String) {
        rectangleLayer.statusMessage = message
        privateShow()
//    	rectangleLayer.bounds
    }
    
    fileprivate func privateDismiss() {
        UIView.animate(withDuration: KVSpinnerViewSettings.fadeOutDuration, animations: {
            self.alpha = 0.0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    fileprivate func privateHandleProgress(_ progress: Progress) {
        progressLayer.string = "\(Int(progress.fractionCompleted * 100))%"
    }
    
}
