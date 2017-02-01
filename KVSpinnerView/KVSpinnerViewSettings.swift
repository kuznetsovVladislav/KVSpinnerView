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
    
    public static var spinnerRadius: CGFloat = 50
    public static var linesWidth: CGFloat = 4
    public static var linesCount = 4
    public static var backgroundOpacity: Float = 1.0
    
    public static var tintColor: UIColor = .white
//    public static var progressTextColor: UIColor = .red
    public static var backgroundRectColor: UIColor = .purple
    public static var statusTextColor: UIColor = .white
    
    public static var minimumDismissDelay = 0.0
    public static var animationDuration = 2.0
    public static var fadeInDuration = 0.3
    public static var fadeOutDuration = 0.3
    
}
