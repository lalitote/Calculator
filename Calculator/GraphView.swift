 //
//  GraphView.swift
//  Calculator
//
//  Created by lalitote on 30.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x:CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    private var originRelativeToCenter: CGPoint = CGPoint() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var geometryReady: Bool = false
    
    @IBInspectable
    var scale: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    var origin: CGPoint {
        get {
            var origin = originRelativeToCenter
            if geometryReady {
                origin.x += center.x
                origin.y += center.y
            }
            return origin
        } set {
            var origin = newValue
            if geometryReady {
                origin.x -= center.x
                origin.y -= center.y
            }
            originRelativeToCenter = origin
        }
    }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            contentScaleFactor *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func changeOrigin(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            origin = recognizer.location(in: self)
        }
    }
    
    
    func moveGraph(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended: fallthrough
        case .changed:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint.zero, in: self)
        default: break
        }
    }

    override func draw(_ rect: CGRect) {
        if !geometryReady && originRelativeToCenter != CGPoint.zero {
            var originHelper = origin
            geometryReady = true
            origin = originHelper
        }
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var firstValue = true
        var point = CGPoint()
        for pixel in 0...Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(pixel) / contentScaleFactor
            if let y = dataSource?.y(x: (point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    firstValue = true
                    continue
                }
                point.y = origin.y - y * scale
                if firstValue  {
                    path.move(to: point)
                    firstValue = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
        path.stroke()
    }
 

}
