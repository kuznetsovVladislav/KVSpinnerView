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
        opacity = KVSpinnerView.settings.backgroundOpacity
        fillColor = nil
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
        
        let startEvenAngle = CGFloat(-Double.pi/2)
        let endEvenAngle = startEvenAngle + CGFloat(Double.pi * 2)
        let startOddAngle = CGFloat(0)
        let endOddAngle = startOddAngle + CGFloat(Double.pi * 2)
        
        let isIndexEven = index % 2 == 1
        let path = UIBezierPath(
            arcCenter: .zero,
            radius: radius - linesDistance * CGFloat(index),
            startAngle: isIndexEven ? startEvenAngle : startOddAngle,
            endAngle: isIndexEven ? endEvenAngle : endOddAngle,
            clockwise: isIndexEven ? true : false)
        return path
    }
    
}
