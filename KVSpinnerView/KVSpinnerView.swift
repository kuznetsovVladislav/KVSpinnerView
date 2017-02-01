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
    
    
    ///	Customizes KVSpinnerView parameters.
    /// Use it before calling methods of KVSpinnerView.
    public static var settings = KVSpinnerViewSettings()

    /// Adds SpinnerView to UIWindow and start animating it
    public static func show() {
        KVSpinnerView.shared.privateShow()
    }
    
    /// Adds SpinnerView to your view and start animating it
    ///	with message.
    /// - Parameter status: message you want to display
    public static func show(saying status: String) {
        KVSpinnerView.shared.privateShow(withMessage: status)
    }

    /// Adds SpinnerView to your view and start animating it
    /// - Parameter view: use from ViewController (for example: self.view).
    public static func show(on view: UIView) {
        KVSpinnerView.shared.privateStartAnimating(on: view)
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message.
    /// - Parameters:
    ///   - view: use from ViewController (for example: self.view).
    ///   - status: message you want to display
    public static func show(on view: UIView, saying status: String) {
        KVSpinnerView.shared.privateStartAnimating(on: view, message: status)
    }
    
    /// Adds SpinnerView to UIWindow and start animating it with given progress.
    /// E.g. Use request progress closure (for example Alamofire .downloadProgress(_ progress))
    //TODO: Make this method work
    private static func showWithProgress() {
        KVSpinnerView.shared.animationTypeIsProgress = true
        KVSpinnerView.shared.privateShowWithProgress()
        KVSpinnerView.shared.privateShow()
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message and progress.
    /// - Parameter status: message you want to display
    //TODO: Make this method work
    private static func showWithProgress(saying status: String) {
        KVSpinnerView.shared.animationTypeIsProgress = true
    	KVSpinnerView.shared.privateShowWithProgress()
        KVSpinnerView.shared.privateShow(withMessage: status)
    }

    /// Removes SpinnerView from either UIWindow or ViewController's view
    /// and stops all animations
    public static func dismiss() {
		KVSpinnerView.shared.privateDismiss()
    }
    
    /// Removes SpinnerView from either UIWindow or ViewController's view
    /// and stops all animations after 'interval' time.
    /// - Parameter interval: incoming progress(use in request progress closure)
    public static func dismiss(after interval: TimeInterval) {
        KVSpinnerView.shared.privateDismiss(afterDelay: interval)
    }
    
    /**
     	Updates progress of KVSpinnerView usinge progress values.
     	Call in from progress closures
     	- parameter progress: e.g. use it in Alamofire .downloadProgress(_ progress) closure.
     	Value has to vary between 0.0 and 1.0
     */
    
    /// Updates progress of KVSpinnerView usinge progress values.
    /// Call in from progress closures
    /// - Parameter progress: e.g. use it in Alamofire .downloadProgress(_ progress) closure.
    ///						  Value has to vary between 0.0 and 1.0
    private static func updateProgress(_ progress: CGFloat) {
        KVSpinnerView.shared.progress = progress
    }
    
    //MARK: - Private variables
    
    fileprivate static var shared = KVSpinnerView()
    
    fileprivate var isAnimating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    fileprivate var circleLayers = [CircleLayer]()
    fileprivate var rectangleLayer = RectangleLayer()
    fileprivate var progressLayer = ProgressLayer()
    
    fileprivate var animationTypeIsProgress = false

    fileprivate var chosenView: UIView?
    
    fileprivate var progress: CGFloat = 0.0 {
        didSet {
            progressDidChange()
        }
    }
    
    //MARK: - Private methods
    
    fileprivate func setup() {
        AnimationManager.shared.managerDelegate = self
        
        /// Rectangle layer
        self.layer.addSublayer(rectangleLayer)
        
        /// Circle layers
        for index in 1 ... KVSpinnerView.settings.linesCount {
            let circleLayer = CircleLayer(index: index)
            circleLayers.append(circleLayer)
            self.layer.addSublayer(circleLayer)
        }
        
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
        if animationTypeIsProgress {
            updateProgressAnimation()
            return
        }
        switch KVSpinnerView.settings.animationStyle {
        case .standart:
            updateStandartAnimation()
        case .infinite:
            updateInfiniteAnimation()
        }
    }
    
    fileprivate func updateStandartAnimation() {
        if isAnimating == true {
            circleLayers.forEach({ (circleLayer) in
                circleLayer.add(AnimationManager.shared.strokeEndAnimation, forKey: "strokeEndAnimation")
                circleLayer.add(AnimationManager.shared.strokeStartAnimation, forKey: "strokeStartAnimation")
            })
        }
        else {
            clearAllAnimation()
        }
    }
    
    fileprivate func updateInfiniteAnimation() {
        if isAnimating == true {

            circleLayers.forEach({ (circleLayer) in
                circleLayer.add(AnimationManager.shared.infiniteStrokeEndAnimation,
                                forKey: "infiniteStrokeStartAnimation")
                circleLayer.add(AnimationManager.shared.infiniteStrokeRotateAnimation(isOdd: circleLayer.index % 2 == 0),
                                forKey: "infiniteStrokeRotateAnimation")
            })
        } else {
            clearAllAnimation()
        }
    }
    
    fileprivate func updateProgressAnimation() {
        if isAnimating == true {
            rectangleLayer.add(AnimationManager.shared.fadeInAnimation, forKey: "rectangleFadeIn")
            for circleLayer in circleLayers {
                circleLayer.add(AnimationManager.shared.fadeInAnimation, forKey: "circlesFadeIn")
//                circleLayer.add(AnimationManager.animateStrokeEnd(toValue: progress), forKey: "strokeEndAnimation")
            }
        } else {
            rectangleLayer.removeAnimation(forKey: "rectangleFadeIn")
            for circleLayer in circleLayers {
                circleLayer.removeAnimation(forKey: "circlesFadeIn")
                circleLayer.removeAnimation(forKey: "strokeEndAnimation")
            }
        }
    }
    
    fileprivate func progressDidChange() {
        let assertion = progress >= 0.0 || progress <= 1.0
        assert(assertion, "Progress value should vary between 0.0 and 1.0")
        if progress == 1.0 {
            KVSpinnerView.dismiss()
        } else {
            for circleLayer in circleLayers {
                circleLayer.add(AnimationManager.shared.animateStrokeEnd(toValue: progress), forKey: "strokeEndAnimation")
            }
        }
    }
    
    //MARK: - Override

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        for circleLayer in circleLayers {
            circleLayer.strokeColor = KVSpinnerView.settings.tintColor.cgColor
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

//MARK: - Private helping methods

fileprivate extension KVSpinnerView {
 
    fileprivate func privateStartAnimating(on view: UIView) {
        clearAllAnimation()
        chosenView = view
        KVSpinnerView.shared.animationTypeIsProgress = false
        rectangleLayer.statusMessage = nil
        self.isAnimating = true
        addSubViewToParentView(view)
    }
    
    fileprivate func privateStartAnimating(on view: UIView, message: String) {
        clearAllAnimation()
        chosenView = view
        KVSpinnerView.shared.animationTypeIsProgress = false
        rectangleLayer.statusMessage = message
        self.isAnimating = true
        addSubViewToParentView(view)
    }
    
    fileprivate func privateShow() {
        clearAllAnimation()
        KVSpinnerView.shared.animationTypeIsProgress = false
        rectangleLayer.statusMessage = nil
        self.isAnimating = true
        addViewToWindow()
    }
    
    fileprivate func privateShow(withMessage message: String) {
        clearAllAnimation()
        KVSpinnerView.shared.animationTypeIsProgress = false
        self.rectangleLayer.statusMessage = message
        self.isAnimating = true
        self.addViewToWindow()
    }
    
    fileprivate func privateShowWithProgress() {
        progress = 0.0
    }
    
    fileprivate func privateDismiss() {
        UIView.animate(withDuration: KVSpinnerView.settings.fadeOutDuration,
                       delay: KVSpinnerView.settings.minimumDismissDelay,
                       options: .curveEaseInOut,
                       animations: {
            self.alpha = 0.0
        }, completion: { (success) in
            self.isAnimating = false
            self.removeFromSuperview()
        })
    }
    
    fileprivate func privateDismiss(afterDelay delay: TimeInterval) {
        let minDelay = KVSpinnerView.settings.minimumDismissDelay
        UIView.animate(withDuration: KVSpinnerView.settings.fadeOutDuration,
                       delay: minDelay > delay ? minDelay : delay,
                       options: .curveEaseInOut,
                       animations: {
            self.alpha = 0.0
        }) { (success) in
            self.isAnimating = false
            self.removeFromSuperview()
        }
    }
    
    //MARK: - 
    
    fileprivate func addViewToWindow() {
        let window = UIApplication.shared.keyWindow!
        let radius = KVSpinnerView.settings.spinnerRadius
        self.frame = CGRect(x: window.bounds.midX,
                            y: window.bounds.midY,
                            width: radius,
                            height: radius)
        self.center = CGPoint(x: window.bounds.midX,
                              y: rectangleLayer.statusMessage == nil ? window.bounds.midY : window.bounds.midY - 30) //Height of textLayer
        self.alpha = 0.0
        window.addSubview(self)
        UIView.animate(withDuration: KVSpinnerView.settings.fadeInDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func addSubViewToParentView(_ parentView: UIView) {
        let radius = KVSpinnerView.settings.spinnerRadius
        self.frame = CGRect(x: parentView.bounds.midX,
                            y: parentView.bounds.midY,
                            width: radius,
                            height: radius)
        
        self.center = CGPoint(x: parentView.bounds.midX,
                              y: rectangleLayer.statusMessage == nil ? parentView.bounds.midY : parentView.bounds.midY - 30)  //Height of textLayer
        self.alpha = 0.0
        parentView.addSubview(self)
        UIView.animate(withDuration: KVSpinnerView.settings.fadeInDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func clearAllAnimation() {
        circleLayers.forEach({ (circleLayer) in
            circleLayer.removeAllAnimations()
        })
    }
}

//MARK: - AnimationManagerDelegate

extension KVSpinnerView: AnimationManagerDelegate {
    
    func managerDidFinishProgressAnimation(_ animation: CAAnimation, _ manager: AnimationManager) {
        AnimationManager.shared.downloadedProgress = progress
    }
    
}
