//
//  KVSpinnerViewSettings.swift
//  KVSpinnerView
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

/**
	Customizes KVSpinnerView parameters.
	Use it before calling methods of shared instance.
 */
public struct KVSpinnerViewSettings {
    
    public enum AnimationStyle {
        case standart
        case infinite
    }
    
    public var animationStyle = AnimationStyle.standart
    
    public var spinnerRadius: CGFloat = 50
    public var linesWidth: CGFloat = 4
    public var linesCount = 4
    public var backgroundOpacity: Float = 1.0
    
    public var tintColor: UIColor = .white
    public var backgroundRectColor: UIColor = .purple
    public var statusTextColor: UIColor = .white
    
    public var minimumDismissDelay = 0.0
    public var animationDuration = 2.0
    public var fadeInDuration = 0.3
    public var fadeOutDuration = 0.3
    
}
