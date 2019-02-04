//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/9/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var newQuestion : Question?;
    var questions = [Question]();
    var questionNum: Int = 0;
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn1: UIButton!
    var LastButtonSelected: UIButton?;
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var QuizResult: UILabel!;
    @IBOutlet weak var QuestionPrompt: UILabel!;
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var QuestionNumLabel: UILabel!
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            StackView.alignment = .center;
            StackView.distribution = .equalSpacing;
            StackView.axis = .horizontal;
            let font = UIFont.boldSystemFont(ofSize: 16)
            Btn1.titleLabel?.font = font;
            Btn2.titleLabel?.font = font;
            Btn3.titleLabel?.font = font;
            Btn4.titleLabel?.font = font;
            Btn5.titleLabel?.font = font;
        } else {
            StackView.spacing = 15.0;
            StackView.axis = .vertical;
            StackView.alignment = .leading;
            let font = UIFont.boldSystemFont(ofSize: 25)
            Btn1.titleLabel?.font = font;
            Btn2.titleLabel?.font = font;
            Btn3.titleLabel?.font = font;
            Btn4.titleLabel?.font = font;
            Btn5.titleLabel?.font = font;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        QuizResult.isHidden = true;
        for i in 0..<Prompt.count{
            questions.append(Question(QuizPrompt: Prompt[i],
                                     Answers: Answers[i],
                                     CorrectAnswer: CorrectAnswers[i]));
        }
        loadNewQuestion();
    }
    
    func loadNewQuestion(){
        if LastButtonSelected !=  nil{
            LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
            LastButtonSelected = nil;
        }
        QuizResult.isHidden = true;
        if questionNum >= questions.count{
            questionNum = 0;
        }
        QuestionPrompt.text = questions[questionNum].QuizPrompt;
        QuestionNumLabel.text = "Question \(questionNum + 1)";
        for i in 0..<questions[questionNum].Answers.count{
            let answer: String = questions[questionNum].Answers[i];
            switch i{
            case 0: Btn1.setTitle("a.) \(answer)", for: .normal);
                Btn1.isHidden = false;
            case 1: Btn2.setTitle("b.) \(answer)", for: .normal);
                Btn2.isHidden = false;
            case 2: Btn3.setTitle("c.) \(answer)", for: .normal);
                Btn3.isHidden = false;
            case 3: Btn4.setTitle("d.) \(answer)", for: .normal);
                Btn4.isHidden = false;
            case 4: Btn5.setTitle("e.) \(answer)", for: .normal);
                Btn5.isHidden = false;
            default: break;
            }
        }
    }
    
    @IBAction func NextButtonSelected(_ sender: UIButton) {
        Btn1.isHidden = true;
        Btn2.isHidden = true;
        Btn3.isHidden = true;
        Btn4.isHidden = true;
        Btn5.isHidden = true;
        questionNum += 1;
        loadNewQuestion();
    }
    
    func UpdateButtons(button: UIButton, isCorrect: Bool){
        let buttonTextColor = isCorrect ? UIColor.green : UIColor.red;
        button.setTitleColor(buttonTextColor, for: UIControl.State.normal);
        if LastButtonSelected !=  nil{
            LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
        }
        LastButtonSelected = button;
    }
    func CheckAnswer(_ tag: Int) -> Bool{
        let isCorrect = questions[questionNum].CorrectAnswer == tag;
        QuizResult.text = isCorrect ? "Correct!" : "Incorrect...";
        QuizResult.isHidden = false;
        return isCorrect;
    }
    
    @IBAction func AnswerSelected(_ sender: UIButton) {
        let isCorrect: Bool = CheckAnswer(sender.tag);
        UpdateButtons(button: sender, isCorrect: isCorrect);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){        //segue.identifier: NewQuestion
        let addQuestionVC = segue.destination as! AddQuestionViewController;
        addQuestionVC.questionNum = self.questions.count + 1;
        print("Prepare Question Num value");
    }
}

