//
//  ViewController.swift
//  Calculator
//
//  Created by lalitote on 10.05.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    private var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction private func clearEverything() {
        brain = CalculatorBrain()
        display.text = "0"
        history.text = " "
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString(".") != nil && digit == "." {
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
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
            history.text = brain.description
                + (brain.isPartialResult ? "..." : "=")
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTypingANumber = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}