//
//  HomeVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/20/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import CoreData

class HomePageVC: UIViewController
{
    //Core Data Variables
    var managedObjectContext: NSManagedObjectContext!;
    var appDelegate: AppDelegate!;
    
    //Notification Variables
    var NotificationPermissionStatus: Bool = false;
    
    //FireBase Variables
    var FB_UserAuth: User?;
    var elected_officials: ElectedOfficials?;
    var current_elections: CurrentElections?;
    
    //Normal Variables
    var address: Address?;
    var email: String!;
    var password: String!;
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);
    @IBOutlet weak var ElectionInfo_Btn: UIButton!
    @IBOutlet weak var ElectedOfficials_Btn: UIButton!
    @IBOutlet weak var VoterRegistry_Btn: UIButton!
    @IBOutlet weak var HeaderMessage: UILabel!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.HeaderMessage.text = "Welcome to Election Day\n Next Election: \(self.current_elections?.election.electionDay ?? "N/A")";
        self.setButtonProps(self.ElectedOfficials_Btn);
        self.setButtonProps(self.VoterRegistry_Btn);
        self.setButtonProps(self.ElectionInfo_Btn);
        self.view.backgroundColor = self.customColor;
    }
    
    func setButtonProps(_ btn: UIButton){
        let width = btn.bounds.size.width;
        btn.layer.cornerRadius = 0.5 * width;
        btn.layer.borderWidth = 3;
        btn.layer.borderColor = UIColor.white.cgColor;
        btn.clipsToBounds = true;
    }
   
    
    @IBAction func RefreshData(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "SegueToLoad", sender: nil);
    }
    
    //Creates an alert with a custom message and title with a single "okay" button to dismiss it
    func SingleActionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
            //User dismisses alert
        });
        alert.addAction(okAction);
        alert.preferredAction = okAction; // only affects .alert style
        present(alert, animated: true, completion: nil);
    }
    
    
    func CheckNotificationStatus() {
        let center = UNUserNotificationCenter.current();
        center.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                self.NotificationPermissionStatus = true;
            } else {
                self.NotificationPermissionStatus = false;
            }
        }
    }
    
    /*
     Will be called from the AppDelegate when the user has opened the notification. This method should extract
     the uniqueId from the notification response and search the quiz array for the question with the uniqueId.
     Then the app should segue to the View Question view for this question.
     If the question does not exist, then the app stays in the Quiz table view.
     */
    func handleNotification(response: UNNotificationResponse){
        //var id = response.notification.request.identifier;
    }
    
    @IBAction func unwindToHomePage(segue: UIStoryboardSegue) {
        if segue.identifier == "UnwindFromLoadData"{
            let vc = segue.source as! LoadDataVC;
            self.elected_officials = vc.elected_officials;
            self.current_elections = vc.current_elections;
        }
        if segue.identifier == "UnwindFromSettings"{
            let vc = segue.source as! SettingsTVC;
            self.address = vc.address;
            self.email = vc.email;
            self.password = vc.password;
        }
    }

    //Called before any segue to another view controller is preformed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToSettings" {
            let vc = segue.destination as! SettingsTVC;
            vc.NotificationPermissionStatus = self.NotificationPermissionStatus == true
                ? "Enabled" : "Disabled";
            vc.address = self.address;
            vc.email = self.email;
            vc.password = self.password;
            vc.managedObjectContext = self.managedObjectContext;
            vc.appDelegate = self.appDelegate;
        }
        else if segue.identifier == "SegueToElectedOfficials" {
            let vc = segue.destination as! ElectedOfficialsTVC;
            if self.elected_officials == nil || self.elected_officials?.officials.count == 0{
                self.SingleActionAlert(
                    title: "Reload Information",
                    message: "Please refresh your data, button in top left, to gather information on your current elected officials.");
            }
            else{
                vc.elected_officials = self.elected_officials!;
                vc.users_state = self.address?.state;
            }
        }
        else if segue.identifier == "SegueToCurrentElections" {
            let vc = segue.destination as! CurrentElectionsTVC;
            if self.current_elections == nil || self.current_elections!.contests.count == 0 {
                self.SingleActionAlert(
                    title: "No Election Information",
                    message: "Either there are no current elections or you need to refresh your data, button in top left, to gather new election information.");
            }
            else {
                vc.current_elections = self.current_elections!;
            }
        }
        else if segue.identifier == "SegueToLoadData" {
            let vc = segue.destination as! LoadDataVC;
            if self.address == nil || self.address?.zip == ""{
                self.SingleActionAlert(
                    title: "Invalid Address",
                    message: "Please update your address first on the settings page.");
            }
            else {
                vc.address = address!;
            }
        }
    }
}
