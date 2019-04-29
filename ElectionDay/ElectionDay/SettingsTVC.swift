//
//  SettingsVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/20/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces

class SettingsTVC: UITableViewController
{
    //Outlets
    @IBOutlet weak var Cell_UsersEmail: UITableViewCell!;
    @IBOutlet weak var Cell_UsersPassword: UITableViewCell!
    @IBOutlet weak var Cell_UsersAddress: UITableViewCell!;
    @IBOutlet weak var Cell_LocationSettings: UITableViewCell!;
    @IBOutlet weak var Cell_NotificationSettings: UITableViewCell!;
    //Core Data Variables
    var managedObjectContext: NSManagedObjectContext!;
    var appDelegate: AppDelegate!;
    //Normal Variables
    var LocationPermissionStatus: String = "";
    var NotificationPermissionStatus: String = "";
    var address: Address?;
    var email: String!;
    var password: String!;
    
    //Cell Related Fields
    var Cells = [[UITableViewCell]]();
    var SelectedCell: UITableViewCell? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.Cells = [
            [self.Cell_UsersEmail, self.Cell_UsersPassword, self.Cell_UsersAddress],
            [self.Cell_NotificationSettings, self.Cell_LocationSettings]
        ];
        self.LocationUseStatusToString();
        self.initCells();
    }
    
    func initCells(){
        //User's Email
        self.Cell_UsersEmail.textLabel?.text = "Email: ";
        self.Cell_UsersEmail.detailTextLabel?.text = self.email;
        //User's Password
        self.Cell_UsersPassword.textLabel?.text = "Password: ";
        self.Cell_UsersPassword.detailTextLabel?.text = self.password;
        //User's Address
        self.Cell_UsersAddress.textLabel?.text = "Address: ";
        self.Cell_UsersAddress.detailTextLabel?.text = self.address?.toString();
        //User's Location Permission
        self.Cell_LocationSettings.textLabel?.text = "Location Use Status: ";
        self.Cell_LocationSettings.detailTextLabel?.text = self.LocationPermissionStatus;
        //User's Notification Settings
        self.Cell_NotificationSettings.textLabel?.text = "Notifications: ";
        self.Cell_NotificationSettings.detailTextLabel?.text = self.NotificationPermissionStatus;
    }
    @IBAction func ReturnToHomePage(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindFromSettings", sender: nil);
    }
    
    func UpdateAddressValue(_ value: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo");
        fetchRequest.predicate = NSPredicate(format: "email = %@", self.email);
        do{
            let fetchResults = try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject];
            if let fetchResult = fetchResults{
                let user = fetchResult.first!;
                user.setValue(value, forKey: "address");
                self.appDelegate.saveContext();
                self.address = Address(value);
                self.Cell_UsersAddress.detailTextLabel?.text = value;
            }
        }
        catch{
            print("Unable to update users address in coredata");
        }
    }
    
    //Determines if the user has authorized the app to know their location
    func LocationUseStatusToString() {
        let status = CLLocationManager.authorizationStatus();
        switch(status){
        case .authorizedAlways: self.LocationPermissionStatus = "Authorized Always";
        case .authorizedWhenInUse: self.LocationPermissionStatus = "Authorized When In Use";
        case .denied, .restricted: self.LocationPermissionStatus = "Denied";
        default: self.LocationPermissionStatus = "Undetermined";
        }
    }
    
    func getUsersAddress(_ sender: UITableViewCell)
    {
        let placePickerController = GMSAutocompleteViewController();
        placePickerController.delegate = self;
        present(placePickerController, animated: true, completion: nil);
    }
    
    func editUserInfo(_ sender: UITableViewCell){
        switch(sender.reuseIdentifier){
        case "UsersEmail":
            break;
        case "UsersPassword":
            break;
        case "UsersAddress":
            self.getUsersAddress(sender);
            break;
        default: break;
        }
    }
    
    
    //gets cell that was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.SelectedCell = self.Cells[indexPath.section][indexPath.row];
        //checks if the cell selected belongs to the local settings section
        let isDeviceSettingsSection = indexPath.section == 0 ? false : true;
        if isDeviceSettingsSection {
            //Open Device Settings from App
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil);
                }
            }
        }
        else{
            self.editUserInfo(self.SelectedCell!);
        }
    }
}

extension SettingsTVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let address = place.formattedAddress {
            self.UpdateAddressValue(address);
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription);
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil);
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
    
}
