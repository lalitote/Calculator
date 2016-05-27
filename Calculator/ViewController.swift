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
        displayValue = nil
    }
    
    @IBAction func backspace(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if var numberOnTheDisplay = display.text {
                numberOnTheDisplay.removeAtIndex(numberOnTheDisplay.endIndex.predecessor())
                if numberOnTheDisplay.isEmpty {
                    numberOnTheDisplay = "0"
                    userIsInTheMiddleOfTypingANumber = false
                }
                display.text = numberOnTheDisplay
            }
        }
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
    
    private var displayValue: Double? {
        get {
            if let text = display.text, value = Double(text) {
            return value
            }
            return nil
        }
        set {
            if let value = newValue {
            display.text = String(value)
            history.text = brain.description
                + (brain.isPartialResult ? "..." : "=")
            } else {
                display.text = "0"
                history.text = " "
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
                brain.setOperand(displayValue!)
                userIsInTheMiddleOfTypingANumber = false
            
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}