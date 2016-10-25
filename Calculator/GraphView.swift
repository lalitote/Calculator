//
//  GraphView.swift
//  Calculator
//
//  Created by lalitote on 25.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    // MARK: Properties
    
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    var scale: CGFloat = 50.0 {didSet {setNeedsDisplay()} }
    
    var origin: CGPoint = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        if resetOrigin {
            origin = center
        }
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
        
    }
    
    
}
