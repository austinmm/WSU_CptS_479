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
    @IBOutlet weak var QuestionPrompt: UILabel!;
    @IBOutlet weak var StackView: UIStackView!
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            StackView.alignment = .center;
            StackView.distribution = .equalSpacing;
            StackView.axis = .horizontal;
            let font = UIFont.boldSystemFont(ofSize: 16)
            Answer1.font = font;
            Answer2.font = font;
            Answer3.font = font;
            Answer4.font = font;
            Answer5.font = font;
        } else {
            StackView.spacing = 15.0;
            StackView.axis = .vertical;
            StackView.alignment = .leading;
            let font = UIFont.boldSystemFont(ofSize: 25)
            Answer1.font = font;
            Answer2.font = font;
            Answer3.font = font;
            Answer4.font = font;
            Answer5.font = font;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Answer1.isHidden = true;
        Answer2.isHidden = true;
        Answer3.isHidden = true;
        Answer4.isHidden = true;
        Answer5.isHidden = true;
        loadNewQuestion();
    }
    
    func loadNewQuestion(){
        QuestionPrompt.text = self.question!.QuizPrompt;
        let answerCount: Int = self.question!.Answers.count;
        for i in 0..<answerCount{
            let answer: String = self.question!.Answers[i];
            switch i{
            case 0: Answer1.text = "a.) \(answer)";
                Answer1.isHidden = false;
            case 1: Answer2.text = "b.) \(answer)";
                Answer2.isHidden = false;
            case 2: Answer3.text = "c.) \(answer)";
                Answer3.isHidden = false;
            case 3: Answer4.text = "d.) \(answer)";
                Answer4.isHidden = false;
            case 4: Answer5.text = "e.) \(answer)";
                Answer5.isHidden = false;
            default: break;
            }
        }
    }
}

