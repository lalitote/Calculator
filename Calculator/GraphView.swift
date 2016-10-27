//
//  GraphView.swift
//  Calculator
//
//  Created by lalitote on 25.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}

class GraphView: UIView {
    
    // MARK: Properties
    
    weak var dataSource: GraphViewDataSource?
    
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
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
    
    // MARK: Actions
    
    func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        var firstValue = true
        var point = CGPoint()
        
        for pixel in 0...Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(pixel)/contentScaleFactor
            if let y = dataSource?.y(x: (point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                point.y = origin.y - y * scale
                if firstValue {
                    path.move(to: point)
                    firstValue = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
        
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        if resetOrigin {
            origin = center
        }
        
        color.set()
        pathForFunction().stroke()
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
        
    }
    
    
}
