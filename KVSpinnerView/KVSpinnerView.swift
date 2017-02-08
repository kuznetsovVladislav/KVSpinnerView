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
        KVSpinnerView.shared.animationTypeIsProgress = false
        KVSpinnerView.shared.startAnimating(onView: nil,
                                            withMessage: nil)
    }
    
    /// Adds SpinnerView to your view and start animating it
    ///	with message.
    /// - Parameter status: message you want to display
    public static func show(saying status: String) {
        KVSpinnerView.shared.animationTypeIsProgress = false
        KVSpinnerView.shared.startAnimating(onView: nil,
                                            withMessage: status)
    }

    /// Adds SpinnerView to your view and start animating it
    /// - Parameter view: use from ViewController (for example: self.view).
    public static func show(on view: UIView) {
        KVSpinnerView.shared.animationTypeIsProgress = false
        KVSpinnerView.shared.startAnimating(onView: view,
                                            withMessage: nil)
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message.
    /// - Parameters:
    ///   - view: use from ViewController (for example: self.view).
    ///   - status: message you want to display
    public static func show(on view: UIView, saying status: String) {
        KVSpinnerView.shared.animationTypeIsProgress = false
        KVSpinnerView.shared.startAnimating(onView: view,
                                            withMessage: status)
    }
    
    /// Adds SpinnerView to UIWindow and start animating it with given progress.
    /// E.g. Use request progress closure (for example Alamofire .downloadProgress(_ progress))
    public static func showProgress() {
        KVSpinnerView.shared.animationTypeIsProgress = true
        KVSpinnerView.shared.startAnimating(onView: nil,
                                            withMessage: nil)
        KVSpinnerView.shared.progressChangesFirstTime = true
        KVSpinnerView.shared.handleProgress(nil, orProgressUnits: 0.05)
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message and progress.
    /// - Parameter status: message you want to display
    public static func showProgress(saying status: String) {
        KVSpinnerView.shared.animationTypeIsProgress = true
        KVSpinnerView.shared.startAnimating(onView: nil,
                                            withMessage: status)
        KVSpinnerView.shared.progressChangesFirstTime = true
        KVSpinnerView.shared.handleProgress(nil, orProgressUnits: 0.05)
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message and progress.
    /// - Parameter view: use from ViewController (for example: self.view).
    public static func showProgress(on view: UIView) {
        KVSpinnerView.shared.animationTypeIsProgress = true
        KVSpinnerView.shared.startAnimating(onView: view,
                                            withMessage: nil)
        KVSpinnerView.shared.progressChangesFirstTime = true
        KVSpinnerView.shared.handleProgress(nil, orProgressUnits: 0.05)
    }
    
    /// Adds SpinnerView to your view and start animating it
    /// with message and progress.
    /// - Parameters:
    ///   - view: use from ViewController (for example: self.view).
    ///   - status: message you want to display
    public static func showProgress(on view: UIView, saying status: String) {
        KVSpinnerView.shared.animationTypeIsProgress = true
        KVSpinnerView.shared.startAnimating(onView: view,
                                            withMessage: status)
        KVSpinnerView.shared.progressChangesFirstTime = true
        KVSpinnerView.shared.handleProgress(nil, orProgressUnits: 0.05)
    }
    
    /// Handles progress of request.
    /// Use this method in 'downloadProgress' closure
    /// - Parameters:
    ///   - progress: progress that you should call from 'downloadProgress' closure
    public static func handle(progress: Progress) {
        KVSpinnerView.shared.progressChangesFirstTime = false
        KVSpinnerView.shared.handleProgress(progress, orProgressUnits: nil)
    }
	
    /// Handles progress of request units.
    /// You should specify number from 1.0 to 1.1.
    /// - Parameter progressUnits: value from 0.0 to 1.0. Use this value if you can't use value of 'Progress' type.
    public static func handle(progressUnits: CGFloat) {
        KVSpinnerView.shared.progressChangesFirstTime = false
        KVSpinnerView.shared.handleProgress(nil, orProgressUnits: progressUnits)
    }

    /// Removes SpinnerView from either UIWindow or ViewController's view
    /// and stops all animations
    public static func dismiss() {
		KVSpinnerView.shared.dismiss()
    }
    
    /// Removes SpinnerView from either UIWindow or ViewController's view
    /// and stops all animations after 'interval' time.
    /// - Parameter interval: incoming progress(use in request progress closure)
    public static func dismiss(after interval: TimeInterval) {
        KVSpinnerView.shared.dismiss(afterDelay: interval)
    }
    
    //MARK: - Private variables
    
    fileprivate static var shared = KVSpinnerView()
    fileprivate var circleLayers = [CircleLayer]()
    fileprivate var rectangleLayer = RectangleLayer()
    fileprivate var progressLayer = ProgressLayer()
    fileprivate var animationTypeIsProgress = false
    fileprivate var progressChangesFirstTime = false
    fileprivate var chosenView: UIView?
    
    fileprivate var isAnimating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
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
                circleLayer.add(AnimationManager.shared.strokeEndAnimation,
                                forKey: "strokeEndAnimation")
                circleLayer.add(AnimationManager.shared.strokeStartAnimation,
                                forKey: "strokeStartAnimation")
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
        if isAnimating {
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
    
    fileprivate func progressDidChange() {
        let assertion = progress >= 0.0 || progress <= 1.0
        assert(assertion, "Progress value should vary between 0.0 and 1.0")
        if progress == 1.0 {
            clearAllAnimation()
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
        fatalError("You have to use 'KVSpinnerView.show()' instead.\n")
    }
}

//MARK: - Private helping methods

fileprivate extension KVSpinnerView {
    
    fileprivate func startAnimating(onView view: UIView?,
                                    withMessage message: String?) {
        clearAllAnimation()
        rectangleLayer.statusMessage = message != nil ? message : nil
        isAnimating = true
        if let view = view {
            chosenView = view
            addSubViewToParentView(view)
        } else {
            addViewToWindow()
        }
    }
    
    fileprivate func handleProgress(_ progress: Progress?,
                                    orProgressUnits units: CGFloat?) {
        if let progress = progress {
            let completed = CGFloat(progress.fractionCompleted)
            if completed > 0.05 || progressChangesFirstTime{
                self.progress = completed
            }
        }
        if let units = units {
            if  units > 0.05 || progressChangesFirstTime {
                self.progress = units
            }
        }
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: KVSpinnerView.settings.fadeOutDuration,
                       delay: KVSpinnerView.settings.minimumDismissDelay,
                       options: .curveEaseInOut,
                       animations: {
            self.alpha = 0.0
        }, completion: { (success) in
            self.isAnimating = false
            self.progress = 0.0
            self.removeFromSuperview()
        })
    }
    
    fileprivate func dismiss(afterDelay delay: TimeInterval) {
        let minDelay = KVSpinnerView.settings.minimumDismissDelay
        UIView.animate(withDuration: KVSpinnerView.settings.fadeOutDuration,
                       delay: minDelay > delay ? minDelay : delay,
                       options: .curveEaseInOut,
                       animations: {
            self.alpha = 0.0
        }) { (success) in
            self.isAnimating = false
            self.progress = 0.0
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
                              y: rectangleLayer.statusMessage == nil ? window.bounds.midY : window.bounds.midY - 30) // Height of textLayer
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
                              y: rectangleLayer.statusMessage == nil ? parentView.bounds.midY : parentView.bounds.midY - 30)  // Height of textLayer
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
