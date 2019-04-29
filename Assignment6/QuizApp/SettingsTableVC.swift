//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 2/17/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import GooglePlaces

class SettingsTableVC: UITableViewController, UITextFieldDelegate{
    @IBOutlet weak var Username: UITextField!;
    @IBOutlet weak var ShuffleLabel: UILabel!;
    @IBOutlet weak var TimeLimitLabel: UILabel!;
    @IBOutlet weak var CategoryLabel: UILabel!;
    @IBOutlet weak var AutoDownloadLabel: UILabel!;
    @IBOutlet weak var TimeLimit: UIStepper!;
    @IBOutlet weak var Shuffle: UISwitch!;
    override func viewDidLoad() {
        super.viewDidLoad();
        self.checkUserDefaults();
        self.setLocalSettings();
        self.setDeviceSettings();
        self.Username.delegate = self;
    }
    
    func checkUserDefaults(){
        let username = UserDefaults.standard.value(forKey: "username");
        if username == nil{
            UserDefaults.standard.set("", forKey: "username") //default value if not already set
        }
        let shuffle = UserDefaults.standard.value(forKey: "shuffle");
        if shuffle == nil{
            UserDefaults.standard.set(true, forKey: "shuffle") //default value if not already set
        }
        let timelimit = UserDefaults.standard.value(forKey: "timelimit");
        if timelimit == nil{
            UserDefaults.standard.set(5, forKey: "timelimit") //default value if not already set
        }
        let category = UserDefaults.standard.value(forKey: "category");
        if category == nil{
            UserDefaults.standard.set("All", forKey: "category") //default value if not already set
        }
        let autodownload = UserDefaults.standard.value(forKey: "autodownload");
        if autodownload == nil{
            UserDefaults.standard.set(true, forKey: "autodownload") //default value if not already set
        }
    }
    
    func setLocalSettings(){
        //Singleton
        let username = UserDefaults.standard.string(forKey: "username") ?? "";
        let shuffle = UserDefaults.standard.bool(forKey: "shuffle");
        self.Shuffle.setOn(shuffle, animated: true);
        let shuffleStr = shuffle ? "Yes" : "No";
        let timelimit = UserDefaults.standard.integer(forKey: "timelimit");
        self.TimeLimit.value = Double(timelimit);
        //Labels & Fields
        self.Username.text = username;
        self.ShuffleLabel.text = "Shuffle: \(shuffleStr)";
        self.TimeLimitLabel.text = "Time Limit: \(timelimit)";
    }
    
    func setDeviceSettings(){
        //Singleton
        let category = UserDefaults.standard.string(forKey: "category") ?? "";
        let autodownload = UserDefaults.standard.bool(forKey: "autodownload") ? "Yes" : "No";
        //Labels & Fields
        self.CategoryLabel.text = "Category: \(category)";
        self.AutoDownloadLabel.text = "Auto Download: \(autodownload)";
    }

    
    //When return key is pressed on keyboard for textfield input
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let username = textField.text ?? "";
        UserDefaults.standard.set(username, forKey: "username");
        self.Username.resignFirstResponder();
        self.view.endEditing(true);
        return false;
    }
    
    @IBAction func ShuffleToggle(_ sender: UISwitch) {
        let shuffle = !UserDefaults.standard.bool(forKey: "shuffle");
        UserDefaults.standard.set(shuffle, forKey: "shuffle");
        let value = shuffle ? "Yes" : "No";
        self.ShuffleLabel.text = "Shuffle: \(value)";
    }
    
    @IBAction func TimeLimitStepper(_ sender: UIStepper) {
        let timelimit = Int(sender.value);
        UserDefaults.standard.set(timelimit, forKey: "timelimit");
        self.TimeLimitLabel.text = "Time Limit: \(timelimit)";
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableView.cellForRow(at: indexPath)!.reuseIdentifier;//restorationIdentifier ?? "";
        if cellType == "DeviceSettingCell" {
            //Open Device Settings from App
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil);
                }
            }
        }
    }
}
