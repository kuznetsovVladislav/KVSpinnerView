//
//  ProgressLayer.swift
//  CALayer
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Владислав . All rights reserved.
//

import UIKit

class ProgressLayer: CATextLayer {
    
    var progress: CGFloat = 0

    override init() {
        super.init()
        string = "\(progress)"
//        foregroundColor = KVSpinnerViewSettings.progressTextColor.cgColor
        frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        fontSize = 24.0
        alignmentMode = CATextLayerAlignmentMode.justified
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
