//
//  ViewController.swift
//  Calculator
//
//  Created by lalitote on 10.05.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    fileprivate var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction fileprivate func clearEverything() {
        displayValue = nil
        brain.clear()
        brain.variableValues = [:]
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if var numberOnTheDisplay = display.text {
                numberOnTheDisplay.remove(at: numberOnTheDisplay.characters.index(before: numberOnTheDisplay.endIndex))
                if numberOnTheDisplay.isEmpty {
                    numberOnTheDisplay = "0"
                    userIsInTheMiddleOfTypingANumber = false
                }
                display.text = numberOnTheDisplay
            }
        } else {
            brain.undo()
            displayValue = brain.result
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?

    @IBAction func memory(_ sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        brain.variableValues = ["M":displayValue!]
        displayValue = brain.result
    }

    @IBAction func variableM(_ sender: UIButton) {
        brain.setOperand(sender.currentTitle!)
        savedProgram = brain.program
    }
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.range(of: ".") != nil && digit == "." {
                return
            } else {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
        }
        userIsInTheMiddleOfTypingANumber = true
    }
    
    fileprivate var displayValue: Double? {
        get {
            if let text = display.text, let value = Double(text) {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = brain.formatter.string(from: NSNumber(value: value))
                history.text = brain.description + (brain.isPartialResult ? "..." : "=")
            } else {
                display.text = "0"
                history.text = " "
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    fileprivate var brain = CalculatorBrain()
    
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
                brain.setOperand(displayValue!)
                userIsInTheMiddleOfTypingANumber = false
            
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destination as UIViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController!
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "plot graph":
                    gvc.title = brain.description == "" ? "Graph" : brain.description
                default:
                    break
                }
            }
        }
    }

}
