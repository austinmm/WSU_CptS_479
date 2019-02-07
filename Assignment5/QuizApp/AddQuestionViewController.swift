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
    var Answers = [UITextField]();
    @IBOutlet weak var Prompt: UITextField!
    @IBOutlet weak var Answer1: UITextField!
    @IBOutlet weak var Answer2: UITextField!
    @IBOutlet weak var Answer3: UITextField!
    @IBOutlet weak var Answer4: UITextField!
    @IBOutlet weak var Answer5: UITextField!
    @IBOutlet weak var CorrectAnswer: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Answers = [Answer1, Answer2, Answer3, Answer4, Answer5];
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
        for i in 0..<self.Answers.count{
            if let answer = self.Answers[i].text {
                if answer.isEmpty != true{
                    validAnswers.append(answer);
                }
            }
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
