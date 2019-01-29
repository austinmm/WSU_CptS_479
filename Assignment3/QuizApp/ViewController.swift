//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/9/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyTimerDelegate {
    func timeChanged(time: Int) {
        timeLabel.text = "\(time)";
    }
    func timesUp(message: String) {
        if(isCorrect == nil){
            self.questionsWrong += 1;
        }
        internalTimer?.invalidate();
        timeLabel.text = message;
        toggleAnswers(isEnabled: false);
        NextButtonSelected(Btn1);
    }
    func handleTick (timer: Timer) {
        myTimer.decrement();
        print("Tick: \(myTimer.currentTime)")
    }
    func startTimer (){
        // Start Timer immediately
        self.timeLabel.text = "\(myTimer.initialTime)";
        internalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: handleTick);
        myTimer.start();
        self.timeLabel.isHidden = false;
    }
    func stopTimer (){
        // Start Timer immediately
        internalTimer?.invalidate();
        myTimer.stop();
        self.timeLabel.isHidden = true;
    }
    func resetTimer (){
        internalTimer?.invalidate();
        myTimer.reset();
        startTimer();
    }
    var isCorrect: Bool?;
    var myTimer: MyTimer = MyTimer(initialTime: 5, message: "Times Up!");
    var internalTimer: Timer?
    var questions = [Question]();
    var questionNum: Int = 0;
    var roundNumber: Int = 0;
    var questionsRight: Int = 0;
    var questionsWrong: Int = 0;
    @IBOutlet weak var timeLabel: UILabel!
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
    
    func toggleAnswers(isEnabled: Bool){
        Btn1.isEnabled = isEnabled;
        Btn2.isEnabled = isEnabled;
        Btn3.isEnabled = isEnabled;
        Btn4.isEnabled = isEnabled;
        Btn5.isEnabled = isEnabled;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NextBtn.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        self.timeLabel.isHidden = true;
        self.roundNumber += 1;
        self.myTimer.delegate = self;
        QuizResult.isHidden = true;
        for i in 0..<Prompt.count{
            questions.append(Question(QuizPrompt: Prompt[i],
                                     Answers: Answers[i],
                                     CorrectAnswer: CorrectAnswers[i]));
        }
        loadNewQuestion();
        startTimer();
    }
    
    func loadNewQuestion(){
        StackView.isHidden = true;
        toggleAnswers(isEnabled: true);
        NextBtn.setTitle("Next", for: .normal);
        if LastButtonSelected !=  nil{
            LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
            LastButtonSelected = nil;
        }
        QuizResult.isHidden = true;
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
        StackView.isHidden = false;
    }
    func displayQuizResults(){
        stopTimer();
        isCorrect = nil;
        if LastButtonSelected !=  nil{
            LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
            LastButtonSelected = nil;
        }
        QuizResult.isHidden = true;
        QuestionPrompt.text = "\(questionsRight) right, \(questionsWrong) wrong." ;
        QuestionNumLabel.text = "Results";
        StackView.isHidden = true;
        NextBtn.setTitle("Again?", for: .normal);
        NextBtn.isHidden = false;
        questionNum = -1;
        questionsRight = 0;
        questionsWrong = 0;
    }
    @IBAction func NextButtonSelected(_ sender: UIButton) {
        Btn1.isHidden = true;
        Btn2.isHidden = true;
        Btn3.isHidden = true;
        Btn4.isHidden = true;
        Btn5.isHidden = true;
        NextBtn.isHidden = true;
        if(isCorrect != nil){
            if isCorrect!{
                self.questionsRight += 1;
            }else{
                self.questionsWrong += 1;
            }
            isCorrect = false;
        }
        questionNum = (questionNum + 1) > self.questions.count ? 0 : questionNum + 1;
        if self.questionNum == self.questions.count{
            displayQuizResults();
        }
        else{
            loadNewQuestion();
            resetTimer();
        }
    }
    
    func UpdateButtons(button: UIButton){
        let buttonTextColor = isCorrect! ? UIColor.green : UIColor.red;
        button.setTitleColor(buttonTextColor, for: UIControl.State.normal);
        if LastButtonSelected !=  nil && LastButtonSelected != button{
            LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
        }
        LastButtonSelected = button;
    }
    func CheckAnswer(_ tag: Int){
        isCorrect = questions[questionNum].CorrectAnswer == tag;
        QuizResult.text = isCorrect! ? "Correct!" : "Incorrect...";
        QuizResult.isHidden = false;
    }
    
    @IBAction func AnswerSelected(_ sender: UIButton) {
        NextBtn.isHidden = false;
        CheckAnswer(sender.tag);
        UpdateButtons(button: sender);
    }
}

