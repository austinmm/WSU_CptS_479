//
//  ViewQuestionViewController.swift
//  QuizApp
//
//  Created by Larry Holder on 2/5/19.
//  Copyright © 2019 Washington State University. All rights reserved.
//

import UIKit

class ViewQuestionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var question: Question!
    var quizQuestionNumber: Int = 0
    var answerLabels: [UILabel]!

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer2Label: UILabel!
    @IBOutlet weak var answer3Label: UILabel!
    @IBOutlet weak var answer4Label: UILabel!
    @IBOutlet weak var answer5Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        answerLabels = [answer1Label, answer2Label, answer3Label, answer4Label, answer5Label]
        self.renderQuestionDetails()
        self.createLeftGesture()
        self.createRightGesture()
    }
    
    func renderQuestionDetails(){
        self.promptLabel.isHidden = true
        promptLabel.text = question.prompt
        self.promptLabel.isHidden = false
        hideLabels()
        for index in 0..<question.answers.count {
            if !question.answers[index].isEmpty {
                answerLabels[index].text = question.answers[index]
                answerLabels[index].isHidden = false
            }
        }
        answerLabels[question.correctAnswerIndex].textColor = UIColor.red
        self.title = "View Question #\(self.quizQuestionNumber+1)"
    }
    
    func createLeftGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToLeftSwipe))
        swipeLeft.direction = .left;
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func createRightGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToRightSwipe))
        swipeRight.direction = .right;
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToLeftSwipe (_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            resetQuestionDetails()
            let QuestionTableVC = navigationController?.viewControllers[0] as! QuizTableViewController
            self.quizQuestionNumber += 1
            if self.quizQuestionNumber >= QuestionTableVC.quiz.count{
                self.quizQuestionNumber = 0;
            }
            self.question = QuestionTableVC.quiz[self.quizQuestionNumber]
            self.renderQuestionDetails()
        }
    }
    @objc func respondToRightSwipe (_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            resetQuestionDetails()
            let QuestionTableVC = navigationController?.viewControllers[0] as! QuizTableViewController
            self.quizQuestionNumber -= 1
            if self.quizQuestionNumber < 0{
                self.quizQuestionNumber = QuestionTableVC.quiz.count-1;
            }
            self.question = QuestionTableVC.quiz[self.quizQuestionNumber]
            self.renderQuestionDetails()
        }
    }
    
    func resetQuestionDetails(){
        self.hideLabels()
        for answerLabel in self.answerLabels{
            answerLabel.textColor = .black
        }
    }
    
    func hideLabels() {
        for label in answerLabels {
            label.isHidden = true
        }
    }

}
