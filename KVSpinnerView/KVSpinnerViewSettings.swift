//
//  KVSpinnerViewSettings.swift
//  KVSpinnerView
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

/// Customizes KVSpinnerView parameters.
/// Use it before calling methods of shared instance.
public struct KVSpinnerViewSettings {
    
    /// Style animation enum
    /// - standart: strokeEnd and strokeStart animations have different start time
    /// - infinite: strokeEnd and strokeStart animations have same start time
    public enum AnimationStyle {
        case standart
        case infinite
    }
    
    /// Style of Animation.
    /// Available: standart(default) and infinite.
    public var animationStyle = AnimationStyle.standart
    
    /// Radius of KVSpinnerView. Default is 50
    public var spinnerRadius: CGFloat = 50
    
    /// Width of each bezier line. Default is 4.0
    public var linesWidth: CGFloat = 4.0
    
    /// Count of KVSpinnerView lines. Default is 4
    public var linesCount = 4
    
    /// Aplha of KVSpinnerView. Default is 1.0
    public var backgroundOpacity: Float = 1.0
    
    /// Color of KVSpinnerView lines. Default is UIColor.white
    public var tintColor: UIColor = .white
    
    /// Color of KVSpinnerView background rectangle (with rounded corners). Default is UIColor.purple
    public var backgroundRectColor: UIColor = .purple
    
    /// Color of CATextLayer text. Default is UIColor.white
    public var statusTextColor: UIColor = .white
    
    /// If you change this value then KVSpinnerView definetely will dismiss after given interval or later.
    /// Default is 0.0
    public var minimumDismissDelay = 0.0
    
    /// Period time interval of one animation. Default is 2.0
    public var animationDuration = 2.0
    
    /// Duration of appearing animation. Default is 0.3
    public var fadeInDuration = 0.3
    
    /// Duration of dissappearing animation. Default is 0.3
    public var fadeOutDuration = 0.3
    
    
}
