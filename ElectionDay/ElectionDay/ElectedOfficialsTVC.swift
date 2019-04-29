//
//  ElectedOfficialsVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/23/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ElectedOfficialsTVC: UITableViewController {
    
    var elected_officials: ElectedOfficials!;
    var selectedRow: Int = 0;
    var users_state: String?;
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.elected_officials.officials.count;
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElectedOfficialCell", for: indexPath);// as! OfficialCell;
        let row = indexPath.row;
        let official = self.elected_officials.officials[row];
        //cell.Official_Name.text = official.name;
        //cell.Official_Title.text = official.officeTitle;
        //cell.setParty(official.party);
        cell.textLabel?.text = official.name;
        cell.textLabel?.textColor = customColor;
        cell.textLabel?.font = .boldSystemFont(ofSize: 18);
        cell.detailTextLabel?.text = official.officeTitle;
        cell.detailTextLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        return cell;
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;
        performSegue(withIdentifier: "SegueToOfficialsDetails", sender: nil);
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToOfficialsDetails" {
            let vc = segue.destination as! OfficialsDetailsVC;
            vc.official = self.elected_officials.officials[self.selectedRow];
            vc.users_state = self.users_state;
        }
    }
}
