//
//  GraphViewController.swift
//  Calculator
//
//  Created by lalitote on 23.10.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    // MARK: Properties
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    var function: ((CGFloat) -> Double)?
    
    func y(x: CGFloat) -> CGFloat? {
        if let function = function {
            return CGFloat(function(x))
        }
        return nil
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
