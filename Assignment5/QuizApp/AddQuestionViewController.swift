//
//  AddQuestionViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/31/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController {
    var questionNum : Int = 0;
    @IBOutlet weak var Prompt: UITextField!
    @IBOutlet weak var Answer1: UITextField!
    @IBOutlet weak var Answer2: UITextField!
    @IBOutlet weak var Answer3: UITextField!
    @IBOutlet weak var Answer4: UITextField!
    @IBOutlet weak var Answer5: UITextField!
    @IBOutlet weak var CorrectAnswer: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title?.append(" \(questionNum)");
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func GetQuestionFields() -> Question{
        var validAnswers: [String] = [];
        if self.Answer1.text?.isEmpty != true {
            validAnswers.append(self.Answer1.text!);
        }
        if self.Answer2.text?.isEmpty != true {
            validAnswers.append(self.Answer2.text!);
        }
        if self.Answer3.text?.isEmpty != true {
            validAnswers.append(self.Answer3.text!);
        }
        if self.Answer4.text?.isEmpty != true {
            validAnswers.append(self.Answer4.text!);
        }
        if self.Answer5.text?.isEmpty != true {
            validAnswers.append(self.Answer5.text!);
        }
        return Question(QuizPrompt: self.Prompt.text!, Answers: validAnswers, CorrectAnswer: self.CorrectAnswer.selectedSegmentIndex);
    }
    @IBAction func Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated:false);
    }
    @IBAction func Save(_ sender: Any) {
        let newQuestion = GetQuestionFields();
        let tableVC = self.navigationController?.viewControllers[0] as! TableViewController;
        tableVC.questions.append(newQuestion);
        tableVC.questionsTable.reloadData();
        self.navigationController?.popViewController(animated:true);
    }
}
