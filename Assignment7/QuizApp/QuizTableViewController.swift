//
//  QuizTableViewController.swift
//  QuizApp
//


import UIKit
import UserNotifications // In AppDelegate.swift

class QuizTableViewController: UITableViewController {
    var alertNotificationsOkay = false // Similarly for badge and sound
    var quiz: [Question] = []
    var selectedRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        initializeQuiz()
    }
    
    func checkNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                self.alertNotificationsOkay = true
            } else {
                self.alertNotificationsOkay = false
            } }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quiz.count
    }
    /*
     Will be called from the AppDelegate when the user has opened the notification. This method should extract
     the uniqueId from the notification response and search the quiz array for the question with the uniqueId.
     Then the app should segue to the View Question view for this question.
     If the question does not exist, then the app stays in the Quiz table view.
    */
    func handleNotification(response: UNNotificationResponse){
        var index = 0;
        for question in self.quiz{
            if response.notification.request.identifier == question.uniqueId{
                self.selectedRow = index;
                performSegue(withIdentifier: "toViewQuestion", sender: nil);
            }
            index += 1;
        }
        print("Invalid Question Unique ID");
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let row = indexPath.row
        let question = quiz[row]
        cell.textLabel?.text = question.prompt
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            quiz.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "toViewQuestion", sender: nil)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddQuestion" {
            let addQuestionVC = segue.destination as! AddQuestionViewController
            addQuestionVC.quizQuestionNumber = quiz.count + 1
        }
        if segue.identifier == "toViewQuestion" {
            let viewQuestionVC = segue.destination as! ViewQuestionViewController
            viewQuestionVC.question = quiz[self.selectedRow]
        }
    }
    
    @IBAction func unwindToQuizView(segue: UIStoryboardSegue) {
        let addQuestionVC = segue.source as! AddQuestionViewController
        if let question = addQuestionVC.quizQuestion {
            quiz.append(question)
            self.tableView.reloadData()
        }
    }

    func initializeQuiz() {
        var question: Question!
        
        // Question 1
        question = Question()
        question.prompt = "Who is the CEO of Apple?"
        question.answers.append("Bill Gates")
        question.answers.append("Steve Jobs")
        question.answers.append("Tim Cook")
        question.answers.append("Larry Holder")
        question.answers.append("None of the above")
        question.correctAnswerIndex = 2
        quiz.append(question)
        
        // Question 2
        question = Question()
        question.prompt = "The earth is which planet from the sun?. This will be a number between 1 and 9 (or 8 if you exclude Pluto). I sure miss Pluto."
        question.answers.append("1")
        question.answers.append("2")
        question.answers.append("3")
        question.answers.append("4")
        question.answers.append("5")
        question.correctAnswerIndex = 2
        quiz.append(question)
        
        // Question 3
        question = Question()
        question.prompt = "2 + 2 = 4?"
        question.answers.append("True")
        question.answers.append("False")
        question.correctAnswerIndex = 0
        quiz.append(question)
    }
}
