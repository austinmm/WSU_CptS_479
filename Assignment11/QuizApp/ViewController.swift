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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Answers = [Answer1, Answer2, Answer3, Answer4, Answer5];
        for i in 0..<self.Answers.count{
            self.Answers[i].isHidden = true;
        }
        self.loadNewQuestion();
    }
    
    func loadNewQuestion(){
        self.QuestionPrompt.text = self.question!.QuizPrompt;
        let answerCount: Int = self.question!.Answers.count;
        for i in 0..<answerCount{
            let answer: String = self.question!.Answers[i];
            self.Answers[i].text = "\(answer)";
            if(self.question?.CorrectAnswer == i){
                self.Answers[i].textColor = .red;
            }
            self.Answers[i].isHidden = false;
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.setStackStyling(spacing: nil, axis: .horizontal, alignment: .center, fontSize: 16.0);

        } else {
            self.setStackStyling(spacing: 15.0, axis: .vertical, alignment: .leading, fontSize: 20.0);
        }
    }
    
    func setStackStyling(spacing: CGFloat?, axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, fontSize: CGFloat){
        if let space = spacing {
            self.StackView.spacing = space;
        } else {
            self.StackView.distribution = .equalSpacing;
        }
        self.StackView.axis = axis;
        self.StackView.alignment = alignment;
        let font = UIFont.boldSystemFont(ofSize: fontSize);
        for i in 0..<self.Answers.count{
            self.Answers[i].font = font;
        }
    }
}
