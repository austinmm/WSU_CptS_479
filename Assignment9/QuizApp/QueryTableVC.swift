//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 3/18/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class QueryTableVC: UITableViewController {
    var Cells: [String] = [];
    var selectedRow: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initializeQueries();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Cells.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "queryCell",
            for: indexPath) as UITableViewCell;
        let row = indexPath.row;
        cell.textLabel?.text = Cells[row];
        return cell;
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true;
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.Cells.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;
        performSegue(withIdentifier: "toLoadQuery", sender: nil);
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoadQuery" {
            let performQueryVC = segue.destination as! LoadQueryVC;
            let place = self.Cells[self.selectedRow ?? 0];
            performQueryVC.place = place;
            performQueryVC.prompt = "Where is the closest " + place + "?";
        }
    }
    
    func initializeQueries() {
        self.Cells.append("Pizza Place");
        self.Cells.append("Grocery Store");
        self.Cells.append("Animal Shelter");
        self.Cells.append("Thai Restaurant");
        self.Cells.append("This Shouldn't Work!");
    }
}

