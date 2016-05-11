//
//  ViewController.swift
//  Calculator
//
//  Created by lalitote on 10.05.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTypingANumber = true
        
    }

    @IBAction func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        if let matemathicalSymbol = sender.currentTitle {
            if matemathicalSymbol == "π" {
                display.text! = String(M_PI)
            }
        }
    }
}