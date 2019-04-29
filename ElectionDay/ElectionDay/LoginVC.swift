//
//  LoginVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/21/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Firebase

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginVC: UIViewController, CLLocationManagerDelegate
{
    //Core Data Variables
    var managedObjectContext: NSManagedObjectContext!;
    var appDelegate: AppDelegate!;

    //View Controller Variables
    @IBOutlet weak var LoadingWheel: UIActivityIndicatorView!
    @IBOutlet weak var PasswordTextInput: UITextField!;
    @IBOutlet weak var EmailTextInput: UITextField!;
    @IBOutlet weak var SubmitBtn: UIButton!;
    
    //Firebase Variables
    var db: Firestore!;
    let officials_collection = "current_officials";
    let contest_collection = "current_contests";
    let election_collection = "current_election";

    //Location Variables
    var locationManager = CLLocationManager();
    
    //Other Variables
    var address: Address?;
    var email: String = "";
    var password: String = "";
    var elected_officials: ElectedOfficials?;
    var current_elections: CurrentElections?;
    
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround();
        self.locationManager.delegate = self;
        self.appDelegate = (UIApplication.shared.delegate as! AppDelegate);
        self.managedObjectContext = self.appDelegate.persistentContainer.viewContext;
        self.setUIElements();
        self.AttemptLogin();
    }
    
    func setUIElements(){
        self.view.backgroundColor = self.customColor;
        self.SubmitBtn.backgroundColor = self.customColor;
        self.SubmitBtn.layer.cornerRadius = 5;
        self.SubmitBtn.layer.borderWidth = 3;
        self.SubmitBtn.layer.borderColor = UIColor.white.cgColor;
        self.SubmitBtn.setTitleColor(.white, for: .normal);
    }
    
    func isHiddenInputFields(_ hide: Bool){
        self.PasswordTextInput.isHidden = hide;
        self.EmailTextInput.isHidden = hide;
        self.SubmitBtn.isHidden = hide;
    }
    
    @IBAction func SubmitBtnSelected(_ sender: UIButton) {
        let email: String? = self.EmailTextInput.text;
        let password: String? = self.PasswordTextInput.text;
        if email == nil && email!.isEmpty
            || password == nil && password!.isEmpty
        {
            self.SingleActionAlert(
                title: "Invalid Text Entry",
                message: "One or more of the text fields are not properly filled out.");
        }
        else{
            self.email = email!;
            self.password = password!;
            self.LoadingWheel.startAnimating();
            self.isHiddenInputFields(true);
            self.AddUserToCoreData(); //add user into coredata
            self.AddUserToFireBase(); //add user to firebase if they don't already exist
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToHomePage"
        {
            // Set HomePage's Current user variables for firebase
            let vc = segue.destination as! HomePageVC;
            vc.FB_UserAuth = Auth.auth().currentUser;
            vc.managedObjectContext = self.managedObjectContext;
            vc.appDelegate = self.appDelegate;
            vc.email = self.email;
            vc.password = self.password;
            vc.address = self.address;
            vc.elected_officials = self.elected_officials;
            vc.current_elections = self.current_elections;
        }
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
    
    func deleteExistingUserEntity(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo");
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest);
        do {
            try managedObjectContext.execute(deleteRequest);
        } catch {
            print("Unable to remove existing UserInfo entities: \(error)")
        }
    }
}

//Location
extension LoginVC
{
    //invoked when the user changes the apps loaction authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(status){
        case .authorizedWhenInUse, .authorizedAlways:
            self.startLocation();
            break;
        case .denied, .restricted:
            self.stopLocation();
            break;
        default:
            self.locationManager.requestWhenInUseAuthorization();
        }
    }
    
    //updates the location manager to retrivee the most recent and accurate info regarding the users loaction
    func startLocation () {
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.startUpdatingLocation();
        self.convertLocationToAddress();
    }
    
    func convertLocationToAddress()
    {
        let geoCoder = CLGeocoder();
        let location = self.locationManager.location;
        if location == nil {return;}
        geoCoder.reverseGeocodeLocation(location!, completionHandler:
            {(placemarks, error) in
                if let err = error
                {
                    print("reverse geodcode fail: \(err)")
                }
                let placeMarks = placemarks! as [CLPlacemark]
                if placeMarks.count == 0{
                    return;
                }
                let placeMark: CLPlacemark! = placeMarks[0];
                self.address = Address();
                self.address?.line1 = placeMark.subThoroughfare ?? "";
                self.address?.line2 = placeMark.thoroughfare ?? "";
                self.address?.city = placeMark.locality ?? placeMark.subAdministrativeArea ?? "";
                self.address?.state = placeMark.administrativeArea ?? "";
                self.address?.zip = placeMark.postalCode ?? "";
        });
    }
    
    //prevents the location manager from pulling/retrieving user location information
    func stopLocation () {
        self.locationManager.stopUpdatingLocation();
    }
    
    // Delegate method called if location unavailable (recommended)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.SingleActionAlert(title: "Error", message: "Failure to process your current location.")
    }
    
}

//Existing Account
extension LoginVC
{
    func AttemptLogin(){
        let isSuccessful = self.GetUserFromCoreData();
        if isSuccessful == false{
            self.LoadingWheel.stopAnimating();
            self.isHiddenInputFields(false);
        }
        else{
            //we add here just incase the user exist in coredat but not in firebase.
            //if they do exist in firebase then the create will catch and error and try to get existing account in turn
            self.AddUserToFireBase();
        }
    }
    
    func GetUserFromFireBase(){
        Auth.auth().signIn(withEmail: self.email, password: self.password) {
            user, error in
            if let err = error {
                self.LoadingWheel.stopAnimating();
                self.isHiddenInputFields(false);
                print("Error: \(err)");
                self.SingleActionAlert(title: "Notice", message: err.localizedDescription);
            } else {
                self.GetUsersDataFromFirebase();
            }
        }
    }
    
    func GetUserFromCoreData() -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo");
        var users: [NSManagedObject]!;
        do {
            users = try self.managedObjectContext.fetch(fetchRequest);
        }
        catch {
            print("Notice: Unable to locate existing UserInfo Entity in CoreData: \(error)");
            return false;
        }
        if users.count == 0 { return false; }
        let user = users[0]; //should only be one entry
        let _email = user.value(forKey: "email") as? String;
        let _password = user.value(forKey: "password") as? String;
        if _email == nil || _password == nil{
            return false;
        }
        self.password = _password!;
        self.email = _email!;
        let tempAddress = user.value(forKey: "address") as! String;
        self.address = Address(tempAddress);
        return true;
    }
}

//New Account
extension LoginVC
{
    
    func AddUserToFireBase(){
        // Create user
        Auth.auth().createUser(withEmail: self.email, password: self.password) {
            authResult, error in
            if let err = error {
                print("Unable to create your account: \(err)");
                //if there is an error then it might be because the user already has a firebase account
                self.GetUserFromFireBase();
            } else {
                self.performSegue(withIdentifier: "SegueToHomePage", sender: nil);
            }
        }
    }
    
    func AddUserToCoreData() {
        self.deleteExistingUserEntity();//ensure we can't make a duplicate entry in our userinfo model
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: self.managedObjectContext);
        user.setValue(self.email, forKey: "email");
        user.setValue(self.password, forKey: "password");
        let tempAddress: String = (self.address == nil) ? "" : self.address?.toString() ?? "";
        user.setValue(tempAddress, forKey: "address");
        self.appDelegate.saveContext();
    }
}


//Get Users data from their existing firebase
extension LoginVC
{
    func GetUsersDataFromFirebase(){
        self.elected_officials = ElectedOfficials();
        self.current_elections = CurrentElections();
        self.db = Firestore.firestore();
        self.getOfficialsData(self.officials_collection);
        //self.getData(self.contest_collection);
        //self.getData(self.election_collection);
    }

    /*
    func loadOfficialsData(_ snapShot: [QueryDocumentSnapshot]?){
        if snapShot != nil {
            for item in snapShot!{
                let official = Official(snapshot: item);
                self.elected_officials?.officials.append(official);
            }
        }
    }
    
    func loadContestData(_ snapShot: [QueryDocumentSnapshot]?){
        if snapShot != nil {
            for item in snapShot!{
                let contest = Contest(snapshot: item);
                self.current_elections?.contests.append(contest);
            }
        }
    }
    
    func loadElectionData(_ snapShot: [QueryDocumentSnapshot]?){
        if snapShot != nil {
            //should only be one election
            if let snap =  snapShot?.first{
                let election = Election(snapshot: snap);
                self.current_elections?.election = election;
            }
        }
    }
    
    func loadData(collection: String, snapShot: [QueryDocumentSnapshot]?){
        switch(collection){
        case self.officials_collection:
            self.loadOfficialsData(snapShot);
            break;
        case self.contest_collection:
            self.loadContestData(snapShot);
            break;
        case self.election_collection:
            self.loadElectionData(snapShot);
            //this gets put in the last load function called
            self.performSegue(withIdentifier: "SegueToHomePage", sender: nil);
            break;
        default: break;
        }
    }
    
    func getData(_ collection: String) {
        var snapShot: [QueryDocumentSnapshot]?;
        Firestore.firestore().collection(collection).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                snapShot = querySnapshot?.documents;
                self.loadData(collection: collection, snapShot: snapShot);
            }
        }
    }
 */
    func getOfficialsData(_ collection: String) {
        db.collection(collection).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapShot = querySnapshot?.documents {
                    for item in snapShot{
                        let official = Official(snapshot: item);
                        self.elected_officials?.officials.append(official);
                    }
                }
            }
            self.getContestsData(self.contest_collection);
        }
    }
    
    func getContestsData(_ collection: String) {
        db.collection(collection).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapShot = querySnapshot?.documents {
                    for item in snapShot{
                        let contest = Contest(snapshot: item);
                        self.current_elections?.contests.append(contest);
                    }
                }
            }
            self.getElectionData(self.election_collection);
        }
    }
    
    func getElectionData(_ collection: String) {
        db.collection(collection).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapShot = querySnapshot?.documents {
                    if let snap =  snapShot.first {
                        let election = Election(snapshot: snap);
                        self.current_elections?.election = election;
                    }
                }
            }
            self.performSegue(withIdentifier: "SegueToHomePage", sender: nil);
        }
    }
}

