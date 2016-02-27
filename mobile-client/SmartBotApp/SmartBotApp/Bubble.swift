//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Bubble : UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        let rect: CGRect = CGRect(x: 0,y:0,width: self.frame.width,height: self.frame.height)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 20.0)
        CGContextAddPath(context, path.CGPath)
        CGContextSetStrokeColorWithColor(context, UIColor(hue: 0.5694, saturation: 1, brightness: 1, alpha: 1.0).CGColor)
        CGContextSetFillColorWithColor(context , UIColor(hue: 0.5861, saturation: 1, brightness: 1, alpha: 1.0).CGColor)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }
}
