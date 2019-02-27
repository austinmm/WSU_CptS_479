//
//  ViewQuestionViewController.swift
//  QuizApp
//


import UIKit
import UserNotifications // In AppDelegate.swift

class ViewQuestionViewController: UIViewController {
    
    var question: Question!
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
        promptLabel.text = question.prompt
        hideLabels()
        for index in 0..<question.answers.count {
            if !question.answers[index].isEmpty {
                answerLabels[index].text = question.answers[index]
                answerLabels[index].isHidden = false
            }
        }
        answerLabels[question.correctAnswerIndex].textColor = UIColor.red
    }

    
    func ScheduleNewNotification() {
        let content = UNMutableNotificationContent();
        content.title = "Question of the Day";
        content.body = self.question.prompt ?? "";
        // Configure trigger for 5 seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false);
        let request = UNNotificationRequest(
                identifier: self.question.uniqueId,
                content: content,
                trigger: trigger);
        // Schedule request
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let theError = error {
                print(theError.localizedDescription)
            } }
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func ScheduleNotification(_ sender: Any) {
        let alert = UIAlertController(title: "Verify Notification",
                                      message: "Are you sure you would like to schedule a notification?", preferredStyle: .alert);
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.ScheduleNewNotification();
        });
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            //self.navigationController?.popViewController(animated: true);
        });
        alert.addAction(yesAction);
        alert.addAction(noAction);
        alert.preferredAction = yesAction; // only affects .alert style
        present(alert, animated: true, completion: nil);
    }
    
    func hideLabels() {
        for label in answerLabels {
            label.isHidden = true
        }
    }

}
