//
//  PerformQueryVC.swift
//  QuizApp
//
//  Created by Austin Marino on 3/18/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LoadQueryVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var place: String = "<Undefined>";
    var prompt: String!;
    var locationManager = CLLocationManager();
    let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075);
    @IBOutlet weak var mapView: MKMapView!;
    @IBOutlet weak var PromptLabel: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.locationManager.delegate = self;
        self.mapView.delegate = self;
        //Request to Use User's Location When App is in Use
        self.PromptLabel.text = self.prompt;
        self.SetMapSettings();
        /*
         Prompts the user to authorize the use of their location when in the app, if that haven't already
         Note: can only be called once in apps life-time
         */
        self.locationManager.requestWhenInUseAuthorization();
    }
    
    //Call once from "viewDidLoad"
    func SetMapSettings(){
        self.mapView.isZoomEnabled = true;
        self.mapView.isRotateEnabled = true;
        self.mapView.showsCompass = true;
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true);
    }
    
    //Sets the map to realign itself to the user's current location
    func SetMapLocation(_ location: CLLocation?){
        self.locationManager.startUpdatingLocation();
        self.mapView.showsUserLocation = true;
        //Deafult Pullman latitude and longitude
        let latitude = location?.coordinate.latitude ?? 46.7298;
        let longitude = location?.coordinate.longitude ?? 117.1817;
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: self.span);
        self.mapView.setRegion(region, animated: true);
    }
    
    // Delegate method called if location unavailable (recommended)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.SingleActionAlert(title: "Error", message: "Failure to process your current location.")
    }
    
    //Determines if the user has authorized the app to know their location
    func IsLocationUseAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus();
        if status == .authorizedWhenInUse{
            return true;
        }
        return false;
    }
    
    //invoked when the user changes the apps loaction authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            self.SetMapLocation(self.locationManager.location);
        }
        else {
            self.locationManager.stopUpdatingLocation();
            self.mapView.showsUserLocation = false;
        }
    }
    
    //When user presses the get answer button
    @IBAction func GetAnswersPressed(_ sender: UIButton) {
        if self.IsLocationUseAuthorized() { //Load the Map
            self.runSearchQuery();
        }
        else{ //location services disabled or not set up properly
            let message = "You have not authorized the use of your location, please do so first.";
            self.CreateSettingsAlert(title: "Notice", message: message);
        }
    }
    
    //prepares the map for the search request
    func runSearchQuery() {
        let request = MKLocalSearch.Request();
        request.naturalLanguageQuery = self.place;
        request.region = self.mapView.region;
        let search = MKLocalSearch(request: request);
        search.start(completionHandler: searchHandler);
    }
 
    //populates the map with the found places or informs user that no places were found
    func searchHandler (response: MKLocalSearch.Response?, error: Error?) {
        if let err = error {
            print("Error occured in search: \(err.localizedDescription)");
            let message = "Unable to fine nearby locations for '" + self.place + "'";
            self.SingleActionAlert(title: "Error", message: message);
        }
        else if let resp = response {
            print("\(resp.mapItems.count) matches found");
            self.mapView.removeAnnotations(self.mapView.annotations);
            for item in resp.mapItems {
                let annotation = MKPointAnnotation();
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                self.mapView.addAnnotation(annotation);
            }
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
    
    //Notifies user that they need to enable location services with an alert
    func CreateSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        //takes user to settings to enable location services
        let okAction = UIAlertAction(title: "Authorize", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil);
                }
            }
        });
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //User dismisses alert
        });
        alert.addAction(okAction);
        alert.addAction(cancelAction);
        alert.preferredAction = okAction; // only affects .alert style
        present(alert, animated: true, completion: nil);
    }

}
