//
//  ViewController.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/19/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
class CurrentElectionsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    var electionTypes = [ "Local", "State", "Federal", "All" ];
    var selectedElectionType: Int = 0;
    var selectedElectionCell: Int = 0;
    var electionCells: [Election] = [];
    @IBOutlet weak var ElectionPicker: UIPickerView!;
    @IBOutlet weak var ElectionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ElectionPicker.delegate = self;
        self.ElectionPicker.dataSource = self;
        self.ElectionTable.delegate = self;
        self.ElectionTable.dataSource = self;
        self.electionCells.append(Election(title: "Defense", canidates: ["Bob", "Tom"]));
        self.electionCells.append(Election(title: "Treasure", canidates: ["David", "Shelby"]));
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.electionTypes.count;
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.electionTypes[row];
    }
    
    // This method is triggered whenever the user makes a change to the picker selection.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The parameter named row and component represents what was selected.
        if self.selectedElectionType != row{
            self.selectedElectionType = row;
           // var type =  ElectionType(rawValue: row);
            //API_Calls.Get(type);
            self.ElectionTable.reloadData();
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.electionCells.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "electionCell", for: indexPath);
        let row = indexPath.row;
        if row == 0{
            cell.textLabel?.text = "Race Title";
            cell.textLabel?.textColor = UIColor(red:0.24, green:0.40, blue:0.54, alpha:1.0)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold);
            cell.detailTextLabel?.text = "Canidate Count";
            cell.detailTextLabel?.textColor = UIColor(red:0.24, green:0.40, blue:0.54, alpha:1.0)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold);
            cell.isUserInteractionEnabled = false;
            cell.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        }
        else{
            cell.textLabel?.text = self.electionCells[row].Title;
            cell.detailTextLabel?.text = "\(self.electionCells[row].Canidates.count)";
            cell.selectionStyle = .none;
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedElectionCell = indexPath.row;
        //performSegue(withIdentifier: "toViewQuestion", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "toAddQuestion" {
    }
}

