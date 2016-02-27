//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Bubble : UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        let rect: CGRect = CGRect(x: 10,y:10,width: self.frame.width-20,height: self.frame.height-20)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 9.0)
        CGContextAddPath(context, path.CGPath)
        CGContextSetStrokeColorWithColor(context, UIColor(hue: 0.5694, saturation: 1, brightness: 1, alpha: 1.0).CGColor)
        CGContextSetFillColorWithColor(context , UIColor(hue: 0.5861, saturation: 1, brightness: 1, alpha: 1.0).CGColor)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }
}
