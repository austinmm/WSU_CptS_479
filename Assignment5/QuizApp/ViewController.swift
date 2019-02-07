//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/9/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var question : Question?;
    @IBOutlet weak var Answer1: UILabel!
    @IBOutlet weak var Answer2: UILabel!
    @IBOutlet weak var Answer3: UILabel!
    @IBOutlet weak var Answer4: UILabel!
    @IBOutlet weak var Answer5: UILabel!
    var Answers = [UILabel]();
    @IBOutlet weak var QuestionPrompt: UILabel!;
    @IBOutlet weak var StackView: UIStackView!
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            StackView.alignment = .center;
            StackView.distribution = .equalSpacing;
            StackView.axis = .horizontal;
            let font = UIFont.boldSystemFont(ofSize: 16)
            for i in 0..<self.Answers.count{
                self.Answers[i].font = font;
            }
        } else {
            StackView.spacing = 15.0;
            StackView.axis = .vertical;
            StackView.alignment = .leading;
            let font = UIFont.boldSystemFont(ofSize: 25)
            for i in 0..<self.Answers.count{
                self.Answers[i].font = font;
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Answers = [Answer1, Answer2, Answer3, Answer4, Answer5];
        for i in 0..<self.Answers.count{
            self.Answers[i].isHidden = true;
        }
        loadNewQuestion();
    }
    
    func loadNewQuestion(){
        QuestionPrompt.text = self.question!.QuizPrompt;
        let answerCount: Int = self.question!.Answers.count;
        let letters: [String] = ["a", "b", "c", "d", "e"];
        for i in 0..<answerCount{
            let answer: String = self.question!.Answers[i];
            self.Answers[i].text = "\(letters[i]).) \(answer)";
            if(self.question?.CorrectAnswer == i){
                self.Answers[i].textColor = .red;
            }
            self.Answers[i].isHidden = false;
        }
    }
}

