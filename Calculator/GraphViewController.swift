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
                target: graphView, action: #selector(GraphView.changeScale(recognizer:))
            ))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.moveGraph(recognizer:))))
            
            let doubleTap = UITapGestureRecognizer(target: graphView, action: #selector(graphView.changeOrigin(recognizer:)))
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
            
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
