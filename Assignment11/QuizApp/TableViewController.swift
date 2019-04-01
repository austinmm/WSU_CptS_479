//
//  TableViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 2/6/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import CoreData
import Foundation

protocol AddQuestionDelegate {
    func addQuestion(_ question: Question);
}

class TableViewController: UITableViewController, AddQuestionDelegate {
    //Core data
    var managedObjectContext: NSManagedObjectContext!;
    var appDelegate: AppDelegate!;
    
    var questions = [Question]();
    var selectedRow: Int = 0;
    @IBOutlet var questionsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //core data
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate;
        self.managedObjectContext = appDelegate.persistentContainer.viewContext;
        //table
        self.questionsTable.delegate = self;
        self.questionsTable.dataSource = self;
        //questions
        self.fetchQuestions();
    }
    /*
     method for fetching questions from CoreData. When the app starts,
     all the questions stored in CoreData should be loaded and displayed
     in the table view.
     */
    func fetchQuestions(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity");
        var questionsDB: [NSManagedObject]!;
        do {
            questionsDB = try self.managedObjectContext.fetch(fetchRequest);
        }
        catch {
            print("fetchQuestions error: \(error)");
        }
        print("Found \(questionsDB.count) questions")
        for questionDB in questionsDB {
            let newQuestion = Question();
            let numAnswers = questionDB.value(forKey: "numAnswers") as! Int;
            for i in 0..<numAnswers{
                let answer = questionDB.value(forKey: "answer\(i+1)") as! String;
                newQuestion.Answers.append(answer);
            }
            newQuestion.CorrectAnswer = questionDB.value(forKey: "correctAnswerIndex") as! Int;
            newQuestion.QuizPrompt = questionDB.value(forKey: "prompt") as! String;
            newQuestion.UniqueId = questionDB.value(forKey: "uniqueId") as! String;
            self.questions.append(newQuestion);
        }

    }
    
    /*Method for adding a new question, which should
    result in adding the question’s data to CoreData. This method should be called upon
    returning from the Add Question view after tapping Save.*/
    func addQuestion(_ question: Question){
        let questionDB = NSEntityDescription.insertNewObject(forEntityName:
            "QuestionEntity", into: self.managedObjectContext);
        questionDB.setValue(question.Answers.count, forKey: "numAnswers");
        let questionCount = question.Answers.count;
        for i in 0..<questionCount {
            questionDB.setValue(question.Answers[i], forKey: "answer\(i+1)");
        }
        questionDB.setValue(question.QuizPrompt, forKey: "prompt");
        questionDB.setValue(question.CorrectAnswer, forKey: "correctAnswerIndex");
        let uniqueId: String = UUID().uuidString;
        questionDB.setValue(uniqueId, forKey: "uniqueId");
        question.UniqueId = uniqueId;
        self.appDelegate.saveContext(); // In AppDelegate.swift
        self.questions.append(question);
        self.questionsTable.reloadData();
    }
    
    /*method for deleting a question. This method
    should be called when the user swipes-to-delete a question in the table.
     You will need some way to uniquely identify the CoreData object corresponding to the deleted question,
     so you can delete that object from CoreData.*/
    
    func deleteQuestion(_ uniqueId: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity");
        fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", uniqueId);
        var questionsDB: [NSManagedObject]!;
        do {
            questionsDB = try self.managedObjectContext.fetch(fetchRequest);
        } catch {
            print("deleteQuestion error: \(error)");
        }
        for questionDB in questionsDB {
            self.managedObjectContext.delete(questionDB);
        }
        self.appDelegate.saveContext(); // In AppDelegate.swift
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
            let id = self.questions[indexPath.row].UniqueId;
            self.deleteQuestion(id);
            self.questions.remove(at: indexPath.row);
            self.questionsTable.deleteRows(at: [indexPath], with: .fade);
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;// retain for prepareForSegue
        performSegue(withIdentifier: "DisplayQuestionSegue", sender: nil);
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
            AddQuestionView.questionNum = self.questions.count + 1;
            AddQuestionView.delegate = self;
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "questionCell", for: indexPath);
        let question = self.questions[indexPath.row];
        cell.textLabel?.text? = question.QuizPrompt;
        return cell;
    }
}
