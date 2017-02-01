//
//  CircleLayer.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

class CircleLayer: CAShapeLayer {
    
    var index: Int
    
    init(index: Int) {
        self.index = index
        super.init()
        path = bezierPath.cgPath
        lineWidth = KVSpinnerView.settings.linesWidth
        fillColor = nil
        opacity = KVSpinnerView.settings.backgroundOpacity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var bezierPath: UIBezierPath {
        return layerPath()
    }
    
    fileprivate func layerPath() -> UIBezierPath {
        
        let radius = KVSpinnerView.settings.spinnerRadius
        let linesDistance = radius / 5
        
        let startEvenAngle = CGFloat(-M_PI_2)
        let endEvenAngle = startEvenAngle + CGFloat(M_PI * 2)
        let startOddAngle = CGFloat(0)
        let endOddAngle = startOddAngle + CGFloat(M_PI * 2)
        
        var path = UIBezierPath()
        if index % 2 == 1 {
            //even
            path = UIBezierPath(
                arcCenter: .zero,
                radius: radius - linesDistance * CGFloat(index),
                startAngle: startEvenAngle,
                endAngle: endEvenAngle,
                clockwise: true)
        } else {
            //odd
            path = UIBezierPath(
                arcCenter: .zero,
                radius: radius - linesDistance * CGFloat(index),
                startAngle: startOddAngle,
                endAngle: endOddAngle,
                clockwise: false)
        }
        return path
    }
    
}
