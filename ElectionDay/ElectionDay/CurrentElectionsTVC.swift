//
//  CurrentElectionsVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/28/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class CurrentElectionsTVC: UITableViewController {

    var current_elections: CurrentElections!;
    var selectedRow: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = self.current_elections.election.name;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return current_elections.contests.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contestCell", for: indexPath);
        let row = indexPath.row;
        let contest = self.current_elections.contests[row];
        cell.textLabel?.text = contest.office;
        cell.detailTextLabel?.text = "\(contest.candidates.count) Canidates";
        return cell;
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;
        performSegue(withIdentifier: "SegueToContestDetails", sender: nil);
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToContestDetails" {
            let vc = segue.destination as! ContestDetailsVC;
            vc.contest = self.current_elections.contests[self.selectedRow];
            //vc.users_state = self.users_state;
        }
    }
}
