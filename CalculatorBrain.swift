//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by lalitote on 12.05.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import Foundation

func factorial(_ op1: Double) -> Double {
    return op1 == 0 ? 1 : op1 * factorial(op1 - 1)
}

class CalculatorBrain
{
    fileprivate var accumulator = 0.0
    fileprivate var internalProgram = [AnyObject]()
    
    fileprivate var currentPrecedence = Int.max
    fileprivate var descriptionAccumulator = "0" {
        didSet {
            if pending == nil {
                currentPrecedence = Int.max
            }
        }
    }
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "" )
            }
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
        descriptionAccumulator = formatter.string(from: NSNumber(value: operand))!
    }
    
    let formatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    
    func setOperand(_ variableName: String) {
        accumulator = variableValues[variableName] ?? 0.0
        descriptionAccumulator = variableName
        internalProgram.append(variableName as AnyObject)
        
    }
    
    var variableValues = [String:Double]() {
        didSet {
            program = internalProgram as CalculatorBrain.PropertyList
        }
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(M_PI),
        "e": Operation.constant(M_E),
        "±": Operation.unaryOperation({ -$0 }, {"-(" + $0 + ")" }),
        "x²": Operation.unaryOperation({pow($0, 2)}, {"(" + $0 + ")²"}),
        "x³": Operation.unaryOperation({pow($0, 3)}, {"(" + $0 + ")³"}),
        "√": Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "cos": Operation.unaryOperation(cos,{"cos(" + $0 + ")"}),
        "sin": Operation.unaryOperation(sin, {"sinh(" + $0 + ")"}),
        "tan": Operation.unaryOperation(tan, {"tan(" + $0 + ")"}),
        "cosh": Operation.unaryOperation(cosh,{"cosh(" + $0 + ")"}),
        "sinh": Operation.unaryOperation(sinh, {"sin(" + $0 + ")"}),
        "tanh": Operation.unaryOperation(tanh, {"tanh(" + $0 + ")"}),
        "log": Operation.unaryOperation(log10, {"log(" + $0 + ")"}),
        "ln": Operation.unaryOperation(log, {"ln(" + $0 + ")"}),
        "x!": Operation.unaryOperation(factorial, { "(" + $0 + ")!"}),
        "10ˣ": Operation.unaryOperation( {pow(10, $0)}, {"10^(" + $0 + ")"} ),
        "×" : Operation.binaryOperation (*, { $0 + "×" + $1 }, 1),
        "÷" : Operation.binaryOperation (/, { $0 + "/" + $1 }, 1),
        "+" : Operation.binaryOperation (+, { $0 + "+" + $1 }, 0),
        "−" : Operation.binaryOperation (-, { $0 + "-" + $1 }, 0),
        "xʸ": Operation.binaryOperation(pow, {$0 + "^" + $1 }, 2),
        "=" : Operation.equals,
        "rand": Operation.random(drand48, "rand()"),
        "%": Operation.unaryOperation({$0 / 100}, { $0 + "%"})
        ]
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case equals
        case random(() -> Double, String)
    }
    
    
    func performOperation(_ symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .unaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .binaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                if currentPrecedence < precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .equals:
                executePendingBinaryOperation()
            case .random(let function, let descriptionRandom):
                accumulator = function()
                descriptionAccumulator = descriptionRandom
            }
        }
    }
    
    fileprivate func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    fileprivate var pending: PendingBinaryOperationInfo?

    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let symbol = op as? String {
                        if operations[symbol] != nil {
                            //symbol is an operation
                            performOperation(symbol)
                        } else {
                            // symbol is a variable
                            setOperand(symbol)
                        }
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        descriptionAccumulator = " "
        currentPrecedence = Int.max
        internalProgram.removeAll()
    }
    
    func undo() {
        internalProgram.removeLast()
        program = internalProgram as CalculatorBrain.PropertyList
    }
        
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
