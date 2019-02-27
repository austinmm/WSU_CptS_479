//
//  AppDelegate.swift
//  QuizApp
//


import UIKit
import UserNotifications // In AppDelegate.swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    // In AppDelegate
    func applicationDidBecomeActive(_ application: UIApplication) {
        let navVC = self.window?.rootViewController as! UINavigationController;
        let questionVC = navVC.viewControllers[0] as! QuizTableViewController;
        questionVC.checkNotifications();
    }
    //Called even if app wasn’t running.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user responded to notification");
        // Do stuff with response here (non-blocking)
        let navVC = self.window?.rootViewController as! UINavigationController;
        var questionVC = navVC.topViewController as? QuizTableViewController;
        if questionVC == nil{
            navVC.popViewController(animated: false);
            questionVC = navVC.topViewController as? QuizTableViewController;
        }
        //let questionVC = navVC.topViewController as! ViewQuestionViewController;
        questionVC!.handleNotification(response: response);
        completionHandler();
    }
    // In AppDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("received notification while in foreground; display?");
        completionHandler([.alert]); // no options ([]) means no notification
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // In didFinishLaunchingWithOptions
        let center = UNUserNotificationCenter.current();
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            // Enable features based on authorization
        };
        // In didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self;
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


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

