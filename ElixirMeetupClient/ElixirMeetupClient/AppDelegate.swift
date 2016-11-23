//
//  AppDelegate.swift
//  ElixirMeetupClient
//
//  Created by Teemu Harju on 22/11/2016.
//  Copyright © 2016 Teemu Harju. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, _) in }
        
        UNUserNotificationCenter.current().delegate = self
        FIRMessaging.messaging().remoteMessageDelegate = self
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(firebaseInstanceIDTokenRefreshed),
                                               name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        NSLog("FCM disconnected.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        firebaseConnectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UNUserNotificationCenterDelegate

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    // MARK: FIRMessagingDelegate
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        NSLog("Received message. msg=\(remoteMessage.appData as! [String : Any])")
    }
    
    // MARK: Private API
    
    @objc private func firebaseInstanceIDTokenRefreshed(notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            NSLog("AppDelegate Firebase token refreshed. token=\(refreshedToken)")
        }
        
        firebaseConnectToFCM()
    }
    
    private func firebaseConnectToFCM() {
        FIRMessaging.messaging().connect() {
            (error) in
            if (error != nil) {
                NSLog("Unable to connect to FCM. error=\(error!.localizedDescription)")
            } else {
                if let token = FIRInstanceID.instanceID().token() {
                    NSLog("Connected to FCM. token=\(token)")
                }
            }
        }
    }
}
