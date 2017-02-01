//
//  RectangleLayer.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

class RectangleLayer: CAShapeLayer {
    
    var statusMessage: String? {
        didSet {
         	updateLayers()
        }
    }
    
    fileprivate let rectSide = KVSpinnerView.settings.spinnerRadius + 80
    
    fileprivate var bezierPath: UIBezierPath {
        return UIBezierPath(roundedRect: CGRect.init(x: -rectSide / 2,
                                                     y: -rectSide / 2,
                                                     width: rectSide,
                                                     height: rectSide), cornerRadius: rectSide / 5)
    }
    
    fileprivate func bezierPathWithStatus(width: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect.init(x: width > rectSide ? -(width/2 + 10) : -rectSide / 2,
                                                     y: -rectSide / 2,
                                                     width: width > rectSide ? width + 20 : rectSide,
                                                     height: rectSide + 30), cornerRadius: rectSide / 5)
    }
    
    fileprivate func setup() {
        path = bezierPath.cgPath
        fillColor = KVSpinnerView.settings.backgroundRectColor.cgColor
    }
    
    fileprivate func updateLayers() {
        if let message = statusMessage {
            sublayers?.removeAll()
            let font = UIFont.systemFont(ofSize: 16.0)
            let messageString = message as NSString
            let messageWidth = messageString.size(attributes: [NSFontAttributeName : font]).width
            path = bezierPathWithStatus(width: messageWidth).cgPath
            let statusLayer = StatusTitleLayer(message: message, 				//TODO: - Perhapse need to extend font in settings
                                               frame: CGRect(
                                                x: messageWidth > rectSide ? -rectSide : 0,
                                                y: 0.0,
                                                width: messageWidth > rectSide ? messageWidth : rectSide,
                                                height: 25))
            let layerPosition = CGPoint(x: bounds.midX, y: 70)
            statusLayer.position = layerPosition
            
            addSublayer(statusLayer)
        } else {
            path = bezierPath.cgPath
            sublayers?.removeAll()
        }
    }
    
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
