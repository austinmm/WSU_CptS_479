//
//  LoadingVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/22/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//
import UIKit
import WebKit
import Firebase

class LoadDataVC: UIViewController
{
    //Firebase Variables
    let db = Firestore.firestore();
    let officials_collection = "current_officials";
    let contest_collection = "current_contests";
    let election_collection = "current_election";
    //HTTP Variables
    let Decoder = JSONDecoder();
    let google_api_key = "AIzaSyDzx3ji8EroCulgX7X9PfD2O1i8BrwRfHU";
    var current_elections_url: String!;
    var current_officials_url: String!;
    //Data Variables
    var address: Address!;
    var elected_officials: ElectedOfficials?;
    var current_elections: CurrentElections?;
    var totalStatusUpdates: Float = 10.0;
    var currentStatsUpdate: Float = 0.0;
    //UI Variables
    @IBOutlet weak var LoadingProgressStatusBar: UIProgressView!
    @IBOutlet weak var LoadingProgressLabel: UILabel!
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);

    override func viewDidLoad() {
        super.viewDidLoad();
        self.LoadingProgressStatusBar.progress = 0.0;
        self.view.backgroundColor = self.customColor;
        self.createUrlStrings();
        self.HTTP_Get_CurrentOfficials();
    }
    
    func createUrlStrings(){
        self.current_elections_url = "https://www.googleapis.com/civicinfo/v2/voterinfo?address=\(self.address.zip)&returnAllAvailableData=true&electionId=2000&key=\(self.google_api_key)";
        self.current_officials_url = "https://www.googleapis.com/civicinfo/v2/representatives?address=\(self.address.zip)&includeOffices=true&key=\(self.google_api_key)";
    }
    
    
    func UpdateLoadStatus(_ message: String) {
        DispatchQueue.main.async(execute: {
            self.LoadingProgressLabel.text = message;
            self.currentStatsUpdate += 1.0;
            self.LoadingProgressStatusBar.progress = self.currentStatsUpdate / self.totalStatusUpdates;
            if self.currentStatsUpdate >= self.totalStatusUpdates
            {
                self.performSegue(withIdentifier: "UnwindFromLoadData", sender: nil);
            }
        });
    }
}

//Generic Firbase Opperations
extension LoadDataVC
{
    //adds collection data to firebase
    func addData(collection: String, document: String, data: [String: Any]) {
        let semaphore = DispatchSemaphore(value: 0);
        DispatchQueue.main.async(execute: {
            self.db.collection(collection).document(document).setData(data) {
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                semaphore.signal();
            }
        });
        semaphore.wait(timeout: DispatchTime.distantFuture);
    }
    
    //gets collection data from firebase
    func getData(_ collection: String) -> [QueryDocumentSnapshot]? {
        var snapShot: [QueryDocumentSnapshot]?;
        let semaphore = DispatchSemaphore(value: 0);
        DispatchQueue.main.async(execute: {
            self.db.collection(collection).getDocuments()
                { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        snapShot = querySnapshot?.documents;
                    }
                    semaphore.signal();
            }
        });
        semaphore.wait(timeout: DispatchTime.distantFuture);
        return snapShot;
    }
    
    //deletes an entry from a collection in firebase
    func deleteData(collection: String, key: String, value: String){
        let semaphore = DispatchSemaphore(value: 0);
        DispatchQueue.main.async(execute: {
            self.db.collection(collection).whereField(key, isEqualTo: value).getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete();
                    }
                }
                semaphore.signal();
            }
        });
        semaphore.wait(timeout: DispatchTime.distantFuture);
    }
    
    //deletes all data in firebase from collection
    func deleteCollection(snapShot: [QueryDocumentSnapshot]?, collection: String, key: String){
        if snapShot != nil {
            for item in snapShot!{
                let value: String = item.data()[key] as! String;
                self.deleteData(collection: collection, key: key, value: value);
            }
        }
    }
}

//Current Officials
extension LoadDataVC
{
    func HTTP_Get_CurrentOfficials(){
        DispatchQueue.main.async(execute: {
            self.UpdateLoadStatus("Loading information about your current officials");
            let url = URL(string: self.current_officials_url);
            let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: self.HandleResponse_CurrentOfficials);
            dataTask.resume();
        });
    }
    
    func deleteOldElectedOfficialsData(){
        self.UpdateLoadStatus("Removing your previously saved current officials information");
        let snapShot = self.getData(self.officials_collection);
        self.deleteCollection(snapShot: snapShot, collection: self.officials_collection, key: "name");
    }
    
    func addNewElectedOfficialsData(){
        self.UpdateLoadStatus("Adding your new current officials information");
        for official in self.elected_officials!.officials {
            self.addData(
                collection: self.officials_collection,
                document: official.name,
                data: official.toDict());
        }
    }
    
    func saveCurrentOfficials(status: String, result: ElectedOfficials?)
    {
        self.UpdateLoadStatus(status);
        if result != nil {
            //process new info
            self.elected_officials = result;
            for office in self.elected_officials!.offices {
                for index in office.officialIndices{
                    self.elected_officials?.officials[index].officeTitle = office.name;
                }
            }
          
            //Delete old elected officials data
            self.deleteOldElectedOfficialsData();
            //add new elected officials data
            self.addNewElectedOfficialsData();
        }
        self.UpdateLoadStatus("Finished processing information about your current officials");
        //Chananingg
        self.HTTP_Get_CurrentElections();
    }
    
    func HandleResponse_CurrentOfficials(data: Data?, response: URLResponse?, error: Error?){
        if let err = error {
            print("error: \(err.localizedDescription)");
            self.saveCurrentOfficials(status: "Failed to load information about your current officials", result: nil);
        } else {
            let httpResponse = response as! HTTPURLResponse;
            let statusCode = httpResponse.statusCode;
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("HTTP \(statusCode) error: \(msg)");
                self.saveCurrentOfficials(status: "Failed to load information about your current officials", result: nil);
            } else {
                // response okay, do something with data
                do{
                    let json: Data! = data!;
                    let result: ElectedOfficials = try self.Decoder.decode(ElectedOfficials.self, from: json);
                    self.saveCurrentOfficials(status: "Saving Current Officials Data", result: result);
                }
                catch{
                    print("Error: Failed to parse json, \(error)");
                    self.saveCurrentOfficials(status: "Failed to load information about your current officials", result: nil);
                }
            }
        }
    }
}

//Current Elections
extension LoadDataVC
{
    func HTTP_Get_CurrentElections(){
        self.UpdateLoadStatus("Loading information about your current elections");
        let url = URL(string: self.current_elections_url);
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: self.HandleResponse_Elections);
        dataTask.resume();
    }
    
    func deleteOldCurrentElectionData(){
        self.UpdateLoadStatus("Removing your previously saved current elections information");
        var snapShot = self.getData(self.contest_collection);
        self.deleteCollection(snapShot: snapShot, collection: self.contest_collection, key: "office");
        snapShot = self.getData(self.election_collection);
        self.deleteCollection(snapShot: snapShot, collection: self.election_collection, key: "id");
    }
    
    func addNewCurrentElectionData(){
        self.UpdateLoadStatus("Adding your new current election information");
        //election contest data
        for contest in self.current_elections!.contests {
            self.addData(
                collection: self.contest_collection,
                document: contest.office,
                data: contest.toDict());
        }
        //general election data
        if let election = self.current_elections?.election {
            self.addData(
                collection: self.election_collection,
                document: election.id,
                data: election.toDict());
        }
    }
    
    func saveCurrentElections(status: String, result: CurrentElections?)
    {
        self.UpdateLoadStatus(status);
        if result != nil {
            //process new info
            self.current_elections = result;
            //removes Referendum type contest as thhey cause errors
            var indexsToRemove = 0;
            if let contest = result?.contests {
                for i in 0..<contest.count {
                    if contest[i].type == "Referendum"{
                        indexsToRemove += 1;
                    }
                }
                self.current_elections?.contests.removeLast(indexsToRemove);
            }
            //Delete old elected officials data
            self.deleteOldCurrentElectionData();
            //add new elected officials data
            self.addNewCurrentElectionData();
        }
        self.UpdateLoadStatus("Finished processing information about your current elections");
    }
    
    func HandleResponse_Elections(data: Data?, response: URLResponse?, error: Error?){
        if let err = error {
            print("error: \(err.localizedDescription)");
            self.saveCurrentElections(status: "Failed to load information about your current elections", result: nil);
        } else {
            let httpResponse = response as! HTTPURLResponse;
            let statusCode = httpResponse.statusCode;
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("HTTP \(statusCode) error: \(msg)");
                self.saveCurrentElections(status: "Failed to load information about your current elections", result: nil);
            } else {
                // response okay, do something with data
                do{
                    let json: Data! = data!;
                    let result: CurrentElections = try self.Decoder.decode(CurrentElections.self, from: json);
                    self.saveCurrentElections(status: "Saving Current Elections Data", result: result);
                }
                catch{
                    print("Error: Failed to parse json, \(error)");
                    self.saveCurrentElections(status: "Failed to load information about your current elections", result: nil);
                }
            }
        }
    }
}
