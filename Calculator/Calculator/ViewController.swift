//
//  ViewController.swift
//  Calculator
//
//  Created by Kacper on 16.02.2015.
//  Copyright (c) 2015 Kacper. All rights reserved.
//

import UIKit
extension String {
  func toEngDouble() -> Double? {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
    if let numberInDouble = numberFormatter.numberFromString(self) {
      return numberInDouble.doubleValue
    }
    return nil
  }
}
class ViewController : UIViewController {
    var userIsInTheMiddleOfWriting = false
  @IBOutlet weak var dotLabel: UIButton!
  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var historyLabel: UILabel!
  
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle
        if userIsInTheMiddleOfWriting {
            display.text = display.text! + digit!
        
        }
        else {
            display.text = digit
            userIsInTheMiddleOfWriting = true
            
        }
    }
  
  
  @IBAction func appendDot() {
    if display.text!.rangeOfString(dotLabel.currentTitle!) == nil && userIsInTheMiddleOfWriting{
      display.text = display.text! + dotLabel.currentTitle!
      
    }
  }
    var operandStack = [Double]()
    var displayValue: Double? {
        get {
          if let displayNumber = display.text!.toEngDouble() {
            return displayNumber
          }
          else {
            return nil
          }
        }
        set {
          if newValue != nil {
            display.text = "\(newValue!)"
          }
          else {
            display.text = "0"
          }
          
          
            userIsInTheMiddleOfWriting = false
        }
    }
  
  @IBAction func backspaceText(sender: AnyObject) {
    if userIsInTheMiddleOfWriting {
      if count(display.text!) >= 1 {
        display.text = dropLast(display.text!)
      }
    }
  }
  
  @IBAction func clearDisplay() {
    operandStack = [Double]()
    displayValue = 0
    println("operandStack: \(self.operandStack)")
    historyLabel.text = ""
  }
    @IBAction func enter() {
        userIsInTheMiddleOfWriting = false
        operandStack.append(displayValue!)
        println("\(operandStack)")
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfWriting {
            enter()
        }
        switch operation {
        case "÷": performOperation{ $1 / $0 }
        case "×": performOperation { $1 * $0 }
        case "+": performOperation {$1 + $0 }
        case "−": performOperation { $1 - $0 }
        case "√": performSingleOperation {sqrt($0)}
        case "sin": performSingleOperation{ sin($0)}
        case "cos": performSingleOperation{ cos($0)}
        case "PI": performConstantOperation(){return M_PI}

        default: break
        }

    
    }
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
  
  @IBAction func changeSign() {
    if userIsInTheMiddleOfWriting {
      displayValue = -displayValue!
    }
    else {
      performSingleOperation(){-$0}
    }
  }

  func performConstantOperation(operation: () -> Double ) {
    displayValue = operation()
    enter()
  }
  
    func performSingleOperation(operation: (Double) -> Double ){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
        
     }


}

