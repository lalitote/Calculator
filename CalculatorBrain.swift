//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by lalitote on 12.05.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import Foundation

func factorial(op1: Double) -> Double {
    return op1 == 0 ? 1 : op1 * factorial(op1 - 1)
}

class CalculatorBrain
{
    private var accumulator = 0.0
    
    private var description = " "
    
    func setOperand(operand: Double) {
        accumulator = operand
        description += "\(operand)"
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "x²": Operation.UnaryOperation({pow($0, 2)}),
        "x³": Operation.UnaryOperation({pow($0, 3)}),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
//        "sinh": Operation.UnaryOperation(sinh),
//        "cosh": Operation.UnaryOperation(cosh),
//        "tanh": Operation.UnaryOperation(tanh),
        "log": Operation.UnaryOperation(log10),
        "ln": Operation.UnaryOperation(log),
        "x!": Operation.UnaryOperation(factorial),
        "10ˣ": Operation.UnaryOperation( {pow(10, $0)} ),
        "×" : Operation.BinaryOperation { $0 * $1 },
        "÷" : Operation.BinaryOperation { $0 / $1 },
        "+" : Operation.BinaryOperation { $0 + $1 },
        "−" : Operation.BinaryOperation { $0 - $1 },
        "xʸ": Operation.BinaryOperation(pow),
        "=" : Operation.Equals
        ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                description += "\(result)"
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                description += "\(result)"
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                description += symbol
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}