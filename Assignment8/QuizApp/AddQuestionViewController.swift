//
//  AddQuestionViewController.swift
//  QuizApp
//
//  Created by Larry Holder on 1/30/19.
//  Copyright © 2019 Washington State University. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextFieldDelegate {
    
    var quizQuestionNumber: Int = 0
    var quizQuestion: Question?

    @IBOutlet weak var promptTextField: UITextField!
    
    @IBOutlet weak var answer1TextField: UITextField!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer3TextField: UITextField!
    @IBOutlet weak var answer4TextField: UITextField!
    @IBOutlet weak var answer5TextField: UITextField!
    
    @IBOutlet weak var correctAnswerSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        promptTextField.delegate = self
        answer1TextField.delegate = self
        answer2TextField.delegate = self
        answer3TextField.delegate = self
        answer4TextField.delegate = self
        answer5TextField.delegate = self
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.title = "Add Question \(quizQuestionNumber)"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        print("saveTapped")
        let question = Question()
        question.prompt = promptTextField.text
        if answer1TextField.text != "" {
            question.answers.append(answer1TextField.text!)
        }
        if answer2TextField.text != "" {
            question.answers.append(answer2TextField.text!)
        }
        if answer3TextField.text != "" {
            question.answers.append(answer3TextField.text!)
        }
        if answer4TextField.text != "" {
            question.answers.append(answer4TextField.text!)
        }
        if answer5TextField.text != "" {
            question.answers.append(answer5TextField.text!)
        }
        question.correctAnswerIndex = correctAnswerSegmentedControl.selectedSegmentIndex
        quizQuestion = question
        performSegue(withIdentifier: "unwindToQuizView", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
