//
//  RectangleLayer.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

class RectangleLayer: CAShapeLayer {
    
    var bezierPath: UIBezierPath {
        let radius = KVSpinnerViewSettings.spinnerRadius
        let rectSide = radius + 80
        return UIBezierPath(roundedRect: CGRect.init(x: -rectSide / 2,
                                                     y: -rectSide / 2,
                                                     width: rectSide ,
                                                     height: rectSide), cornerRadius: rectSide / 5)
    }
    
    override init() {
        super.init()
        path = bezierPath.cgPath
        fillColor = KVSpinnerViewSettings.backgroundRectColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
