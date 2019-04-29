//
//  AppDelegate.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/19/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import GooglePlaces //Used to autocomplete while retriving user's address
import UserNotifications
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    
    //***** Code for Notification Handling *****
    
    //Called even if app wasn’t running.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user responded to notification");
        // Do stuff with response here (non-blocking)
        //let homeVC = self.popToHomePage();
        //let questionVC = navVC.topViewController as! ViewQuestionViewController;
        //homeVC.handleNotification(response: response);
        completionHandler();
    }
    
    //***** Pre-Existing AppDelegate Functions *****
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // In didFinishLaunchingWithOptions
        let center = UNUserNotificationCenter.current();
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            // Enable features based on authorization
        };
        // In didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self;
        //API Key used for google Places
        GMSPlacesClient.provideAPIKey("AIzaSyAcmKXjOONxIvfmaB8DvAdgecNBGzQS_4Q");
        //firebase
        FirebaseApp.configure();
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //let homeVC = self.popToHomePage();
        //homeVC.CheckNotificationStatus();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext();
    }
    
    func popToHomePage() -> HomePageVC {
        let navVC = self.window?.rootViewController as! UINavigationController;
        var homeVC = navVC.topViewController as? HomePageVC;
        //This would mean that the current top VC was not the Home Page so we need to pop to get to it
        while homeVC == nil {
            navVC.popViewController(animated: false);
            homeVC = navVC.topViewController as? HomePageVC;
        }
        return homeVC!;
    }
    
    //***** Core Data Functions *****
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ElectionDayModel");
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error, \((error as NSError).userInfo)");
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

