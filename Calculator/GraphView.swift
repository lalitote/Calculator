//
//  GraphView.swift
//  Calculator
//
//  Created by lalitote on 30.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    var scale: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    var origin: CGPoint = CGPoint() {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        if resetOrigin {
            origin = convert(center, from: superview)
        }
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
    }
 

}
