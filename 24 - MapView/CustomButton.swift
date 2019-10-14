//
//  CustomButton.swift
//  24 - MapView
//
//  Created by Lorem on 3/17/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shakeButton()
    } // we  initialize CustomButton
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       shakeButton()
    }
 
    
    func shakeButton() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration      = 0.1
        shake.repeatCount   = 1
        shake.autoreverses  = true
        let fromPoint       = CGPoint(x: center.x - 3, y: center.y - 2)
        let fromValue       = NSValue(cgPoint: fromPoint)
        let toPoint         = CGPoint(x: center.x + 3, y: center.y + 2)
        let toValue         = NSValue(cgPoint :toPoint)
        shake.fromValue     = fromValue
        shake.toValue       = toValue
        layer.add(shake, forKey: "position")
        
    }
}

