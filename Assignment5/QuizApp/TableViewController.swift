//
//  TableViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 2/6/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var questions = [Question]();
    //var basicCells = [UITableViewCell]();
    var selectedRow: Int = 0;
    @IBOutlet var questionsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionsTable.isHidden = true;
        self.questionsTable.delegate = self;
        self.questionsTable.dataSource = self;
        //self.questionsTable.beginUpdates()
        for i in 0..<Prompt.count{
            self.questions.append(Question(QuizPrompt: Prompt[i],
                                      Answers: Answers[i],
                                      CorrectAnswer: CorrectAnswers[i]));
        }
        self.questionsTable.isHidden = false;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true;
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source first
            self.questions.remove(at: indexPath.row);
            self.questionsTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row // retain for prepareForSegue
        performSegue(withIdentifier: "DisplayQuestionSegue", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.basicCells.count;
        return self.questions.count;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DisplayQuestionSegue") {
            let DisplayQuestionView = segue.destination as! ViewController;
            DisplayQuestionView.question = self.questions[self.selectedRow];
        }
        else if (segue.identifier == "AddQuestionSegue") {
            let AddQuestionView = segue.destination as! AddQuestionViewController;
            AddQuestionView.questionNum = self.questions.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "questionCell", for: indexPath);
        let question = self.questions[indexPath.row];
        cell.textLabel?.text? = question.QuizPrompt;
        return cell;
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
