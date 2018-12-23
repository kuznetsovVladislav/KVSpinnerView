//
//  StatusTitleLayer.swift
//  KVSpinnerView
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

class StatusTitleLayer: CATextLayer {
    
    var message: String
    
    init(message: String, frame: CGRect) {
        self.message = message
        super.init()
        setup()
        self.frame = frame
    }
    
    fileprivate func setup() {
        string = message
        font = UIFont.systemFont(ofSize: 16.0)	//TODO: Change realization to SpinnerSettings
        fontSize = 16.0
        contentsScale = UIScreen.main.scale
        alignmentMode = CATextLayerAlignmentMode.center
        foregroundColor = KVSpinnerView.settings.statusTextColor.cgColor
        isWrapped = true
        
        truncationMode = CATextLayerTruncationMode(rawValue: "middle")
//        backgroundColor = UIColor.red.cgColor // <- Uncomment to see layers frame borders
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}
