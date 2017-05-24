//
//  ViewController.swift
//  Excercise1A2B
//
//  Created by Tseng, Ling-Chia on 2017/5/24.
//  Copyright © 2017年 Tseng, Ling-Chia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var answer = ""
    var count = 0
    
    @IBOutlet weak var answerText: UITextField!
    
    @IBOutlet weak var historyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answer = random_answer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendAction(_ sender: Any) {
        
        var duplicate = false
        
        
        if answerText.text?.characters.count == 4{
            for char in (answerText.text?.characters)!{
                if (answerText.text?.count(of: String(char)))! > 1{
                    duplicate = true
                }
                
            }
            
            if !duplicate{
                let result = guess(guessNumber: answerText.text!)
                historyText.text = historyText.text + "\(result)\n"
                answerText.text = ""
                count += 1
            }else{
                showAlert("do not key in same numbers!", viewController: self)
            }
            
        }else{
            showAlert("should have 4 numbers", viewController: self)
        }
    }
    
    @IBAction func restartAction(_ sender: Any) {
        
        reset()
        
        showAlert("Restart!!", viewController: self)
        
    }
    
    func reset(){
        answer = random_answer()
        answerText.text = ""
        historyText.text = ""
        count = 0
    }

    func random_answer() -> String{
        var ans = ""
        
        while (true){
            let random  = String(Int(arc4random() % 9) + 1)
            if !ans.contains(random){
                ans.append(random)
            }
            if ans.characters.count >= 4{
                return ans
            }
        }
    }
    
    func guess(guessNumber: String) -> String{
        let answer_array = Array(answer.characters)
        
        let guessArray = Array(guessNumber.characters)
        
        var a = 0
        var b = 0
        
        for i in 0...3{
            
            if answer_array[i] == guessArray[i]{
                a += 1
            }else if answer.contains("\(guessArray[i])"){
                b += 1
            }
            
        }
        if a == 4{
            showAlertWithRestart(String(format: "correct by %d times!!\nthe answer is %@\npress OK to restart.", count, answer), viewController: self)
            
        }
        
        let result = String(format: "%dA%dB", a, b)
        
        return String(format: "%@  %@", guessNumber, result)
    }
    
    func showAlert(_ msg: String, title: String = "Message", viewController: UIViewController){
        
        let alertController = UIAlertController(
            title: title,
            message: "\(msg)",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .destructive,
            handler: nil)
        
        
        
        alertController.addAction(okAction)
        
        
        viewController.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
    func showAlertWithRestart(_ msg: String, title: String = "Message", viewController: UIViewController){
        
        let alertController = UIAlertController(
            title: title,
            message: "\(msg)",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .destructive,
            handler: { action in
                self.reset()
                
        })
        
        
        
        alertController.addAction(okAction)
        
        
        viewController.present(
            alertController,
            animated: true,
            completion: nil)
        
    }

}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let countOfWords = string.characters.count +  textField.text!.characters.count - range.length
        if countOfWords > 4{
            return false
        }
        
        //only numbers can be input
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
}

extension String{
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
}

