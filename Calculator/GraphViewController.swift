//
//  GraphViewController.swift
//  Calculator
//
//  Created by lalitote on 28.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: self, action: #selector(changeScale(recognizer:))
            ))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveGraph(recognizer:))))
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(changeOrigin(recognizer:)))
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
            
            if !resetOrigin {
                graphView.origin = origin
            }
            graphView.scale = scale
            
        }
    }
    
    private var resetOrigin: Bool {
        get {
            if let originArray = defaults.object(forKey: Keys.Origin) as? [CGFloat] {
                return false
            }
            return true
        }
        
    }
    
    private struct Keys {
        static let Scale = "GraphViewController.Scale"
        static let Origin = "GraphViewController.Origin"
    }
    
    private let defaults = UserDefaults.standard
    
    var scale: CGFloat {
        get {
            return defaults.object(forKey: Keys.Scale) as? CGFloat ?? 50.0
        }
        set {
            defaults.set(newValue, forKey: Keys.Scale)
        }
    }
    
    private var origin: CGPoint {
        get {
            var origin = CGPoint()
            if let originArray = defaults.object(forKey: Keys.Origin) as? [CGFloat] {
                origin.x = originArray.first!
                origin.y = originArray.last!
            }
            return origin
        }
        set {
            defaults.set([newValue.x, newValue.y], forKey: Keys.Origin)
        }
    }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        graphView.changeScale(recognizer: recognizer)
        if recognizer.state == .ended {
            scale = graphView.scale
            origin = graphView.origin
        }
    }
    
    func moveGraph(recognizer: UIPanGestureRecognizer) {
        graphView.moveGraph(recognizer: recognizer)
        if recognizer.state == .ended {
            origin = graphView.origin
        }
    }
    
    func changeOrigin(recognizer: UITapGestureRecognizer) {
        graphView.changeOrigin(recognizer: recognizer)
        if recognizer.state == .ended {
            origin = graphView.origin
        }
    }
    
    
    var function: ((CGFloat) -> Double)?
    
    func y(x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        return nil
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
