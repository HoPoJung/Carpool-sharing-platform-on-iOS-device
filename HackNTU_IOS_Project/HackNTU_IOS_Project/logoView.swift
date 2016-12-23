//
//  logoView.swift
//  HackNTU_IOS_Project
//
//  Created by Yuan-Pu Hsu on 21/12/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

import UIKit

class logoView: UIView {

    var centerOfLogoView: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var halfOfViewSize: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2
    }
    var lineWidth: CGFloat = 2
    var full = CGFloat(M_PI*2)
    var porportion = CGFloat(M_PI*2*Shared.shared.coin/Shared.shared.fullCoin)
    
    func drawCircleCenterAt(center:CGPoint, withRadius radius:CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 00,
                                      endAngle: full,
                                      clockwise: true)
        //circlePath.lineWidth = lineWidth
        return circlePath
    }
    func drawCoinProportionCircle(center:CGPoint, withRadius radius:CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: porportion,
                                      clockwise: true)
        circlePath.lineWidth = lineWidth
        return circlePath
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        UIColor.white.withAlphaComponent(0.5).set()
        drawCircleCenterAt(center: centerOfLogoView, withRadius: halfOfViewSize).fill()
        UIColor.yellow.set()
        drawCoinProportionCircle(center: centerOfLogoView, withRadius: halfOfViewSize-lineWidth).stroke()
    }

}
