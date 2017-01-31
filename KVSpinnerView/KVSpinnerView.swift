//
//  SpinningView.swift
//  CALayer
//
//  Created by Владислав  on 30.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

//MARK: - Settings


/// Customizes KVSpinnerView parameters.
/// Use it before calling methods of shared instance.
public struct KVSpinnerViewSettings {
    public static var spinnerRadius: CGFloat = 50
    public static var linesWidth: CGFloat = 4
    public static var linesCount = 4
    public static var backgroundOpacity: Float = 1.0
    
    public static var tintColor: UIColor = .white
    public static var backgroundColor: UIColor? = nil
    public static var progressTextColor: UIColor = .red
    public static var backgroundRectColor: UIColor = .purple
    
	public static var animationDuration = 2.0
    public static var fadeInDuration = 0.3
    public static var fadeOutDuration = 0.3
}

//MARK: - KVSpinnerView

public class KVSpinnerView: UIView {
    
    //MARK: - Public Static
    
    /// You only should invoke shared instance to use any methods
    /// of KVSpinnerView
    public static var shared = KVSpinnerView()
    
    /// Adds SpinnerView to your view and start animating it
    /// - parameter view: use from ViewController (for example: self.view).
    public func startAnimating(on view: UIView) {
        privateStartAnimating(on: view)
    }
    
    /// Adds SpinnerView to UIWindow and start animating it
    public func show() {
		privateShow()
    }
    
    /// Removes SpinnerView from either UIWindow or ViewController's view
    public func dismiss() {
		privateDismiss()
    }
    
    /// Handles incoming progress. You should call it in
    /// request progress closure (for example Alamofire .downloadProgress(_ progress))
    /// - parameter progress: incoming progress
    public func handleProgress(_ progress: Progress) {
        privateHandleProgress(progress)
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
