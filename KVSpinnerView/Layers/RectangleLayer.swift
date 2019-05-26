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
    
    fileprivate func bezierPathWithStatus(width: CGFloat, height: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: CGRect.init(x: width > rectSide ? -(width / 2 + 10) : -rectSide / 2 - 10,
                                                     y: -rectSide / 2,
                                                     width: width > rectSide ? width + 20 : rectSide + 20,
                                                     height: rectSide + height),
                            cornerRadius: rectSide / 5)
    }
    
    fileprivate func setup() {
        path = bezierPath.cgPath
        fillColor = KVSpinnerView.settings.backgroundRectColor.cgColor
    }
     				//TODO: - Perhapse need to extend font in settings
    fileprivate func updateLayers() {
        if let message = statusMessage {
            sublayers?.removeAll()
            let font = UIFont.systemFont(ofSize: 16.0)
            var isTextWrapped = false
            
            let messageString = message as NSString
            var messageWidth = messageString.size(withAttributes: [NSAttributedString.Key.font : font]).width
            if messageWidth > 200 {
                isTextWrapped = true
                messageWidth = 200
            }
            
            let attributes = [NSAttributedString.Key.font : font]
            let attributedString = NSAttributedString(string: message,
                                                      attributes: attributes)
            
            let rect = attributedString.boundingRect(
                with: CGSize.init(width: 200, height: 10000),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil)

            let messageHeight = rect.size.height

            
            path = bezierPathWithStatus(width: messageWidth, height: messageHeight).cgPath
            let statusLayer = StatusTitleLayer(message: message,
                                               frame: CGRect(
                                                x: bounds.midX - max(messageWidth, rectSide) / 2,
                                                y: KVSpinnerView.settings.spinnerRadius,
                                                width: max(messageWidth, rectSide),
                                                height: isTextWrapped ? messageHeight : 25))
//            let radius = KVSpinnerView.settings.spinnerRadius
//            let layerPosition = CGPoint(x: bounds.midX, y: radius + frame.size.height)
//            statusLayer.position = layerPosition
            
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
