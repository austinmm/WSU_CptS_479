//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/9/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var questions = [Question]();
    var questionNum: Int = 0;
    let urlString = URL(string: "https://opentdb.com/api.php?amount=5");
    @IBOutlet weak var AnswerBtn4: UIButton!
    @IBOutlet weak var AnswerBtn3: UIButton!
    @IBOutlet weak var AnswerBtn2: UIButton!
    @IBOutlet weak var AnswerBtn1: UIButton!;
    var AnswerBtns: [UIButton] = [];
    var LastButtonSelected: UIButton?;
    @IBOutlet weak var QuizResult: UILabel!;
    @IBOutlet weak var QuestionPrompt: UILabel!;
    @IBOutlet weak var StackView: UIStackView!;
    @IBOutlet weak var LoadingWheel: UIActivityIndicatorView!
    @IBOutlet weak var NewQuizBtn: UIButton!
    @IBOutlet weak var NextBtn: UIButton!
    
    //Used for device orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            for btn in self.AnswerBtns{
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular);
            }
        } else {
            for btn in self.AnswerBtns{
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular);
            }
        }
    }
    
    func hideQuestionFields(){
        self.QuestionPrompt.isHidden = true;
        self.QuizResult.isHidden = true;
        for btn in self.AnswerBtns{
            btn.isHidden = true;
        }
        self.NextBtn.isHidden = true;
        self.NewQuizBtn.isHidden = true;
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        self.AnswerBtns = [AnswerBtn1, AnswerBtn2, AnswerBtn3, AnswerBtn4];
        DispatchQueue.main.async {
            self.getNewQuestions();
        }
    }
    
    func getNewQuestions(){
        self.hideQuestionFields();
        self.questions = [];
        self.questionNum = 0;
        self.title = "...";
        self.LoadingWheel.isHidden = false;
        self.QuestionPrompt.isHidden = false;
        self.QuestionPrompt.text = "Loading New Questions, Please Wait...";
        let dataTask = URLSession.shared.dataTask(with: self.urlString!, completionHandler: handleResponse);
        dataTask.resume();
    }
    
    func handleResponse (data: Data?, response: URLResponse?, error: Error?) {
        if let err = error {
            self.QuestionPrompt.text = "Notice: Failure to load new questions...";
            print("error: \(err.localizedDescription)");
        } else {
            let httpResponse = response as! HTTPURLResponse;
            let statusCode = httpResponse.statusCode;
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode);
                self.QuestionPrompt.text = "Notice: Failure to load new questions...";
                print("HTTP \(statusCode), error: \(msg)");
            }
            else{
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!) {
                    var jsonDict = jsonObj as! [String: Any];
                    let dictArr = jsonDict["results"] as! [NSDictionary];
                    self.processNewQuestions(dictArr);
                    self.loadQuestion();
                } else {
                    self.QuestionPrompt.text = "Notice: Failure to load new questions...";
                    print("Error: Invalid JSON Data");
                }
            }
        }
    }
    
    func processNewQuestions(_ dataStr: [NSDictionary])
    {
        for i in 0..<dataStr.count {
            var question = dataStr[i]["question"] as! String;
            question = question.html2String;
            var allAnswers = dataStr[i]["incorrect_answers"] as! [String];
            let correctAnswer = dataStr[i]["correct_answer"] as! String;
            allAnswers.append(correctAnswer);
            for i in 0..<allAnswers.count {
                allAnswers[i] = allAnswers[i].html2String;
            }
            allAnswers.shuffle();
            let correctIndex = allAnswers.firstIndex(of: correctAnswer);
            self.questions.append(
                Question(QuizPrompt: question,
                         Answers: allAnswers,
                         CorrectAnswer: correctIndex ?? 0)
            );
        }
    }
    
    func loadQuestion(){
        DispatchQueue.main.async {
            let numbering = ["A", "B", "C", "D"];
            self.LoadingWheel.isHidden = true;
            if self.LastButtonSelected != nil{
                self.LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
                self.LastButtonSelected = nil;
            }
            if self.questionNum >= self.questions.count{
                self.questionNum = 0;
            }
            self.QuestionPrompt.text = self.questions[self.questionNum].QuizPrompt;
            self.title = "Question \(self.questionNum + 1)";
            for i in 0..<self.questions[self.questionNum].Answers.count{
                let answer: String = self.questions[self.questionNum].Answers[i];
                self.AnswerBtns[i].setTitle("\(numbering[i]).) \(answer)", for: .normal);
                self.AnswerBtns[i].isHidden = false;
            }
            self.QuestionPrompt.isHidden = false;
            self.NextBtn.isHidden = false;
            self.NewQuizBtn.isHidden = false;
        }
    }
    
    @IBAction func NextButtonSelected(_ sender: UIButton) {
        self.hideQuestionFields();
        self.questionNum += 1;
        self.loadQuestion();
    }
    
    func UpdateButtons(button: UIButton, isCorrect: Bool){
        let buttonTextColor = isCorrect ? UIColor.green : UIColor.red;
        button.setTitleColor(buttonTextColor, for: UIControl.State.normal);
        if self.LastButtonSelected != nil && self.LastButtonSelected != button{
            self.LastButtonSelected!.setTitleColor(UIColor.blue, for: UIControl.State.normal);
        }
        self.LastButtonSelected = button;
    }
    
    func CheckAnswer(_ tag: Int) -> Bool{
        let isCorrect = questions[questionNum].CorrectAnswer == tag;
        self.QuizResult.text = isCorrect ? "Correct!" : "Incorrect...";
        self.QuizResult.isHidden = false;
        return isCorrect;
    }
    
    @IBAction func AnswerSelected(_ sender: UIButton) {
        let isCorrect: Bool = CheckAnswer(sender.tag);
        self.UpdateButtons(button: sender, isCorrect: isCorrect);
    }
    
    @IBAction func NewQuizBtnPressed(_ sender: UIButton) {
        self.getNewQuestions();
    }
}
