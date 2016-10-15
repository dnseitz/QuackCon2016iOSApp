//
//  AppDelegate.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var endpointArn: String? = nil
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    registerForPushNotifications(application)
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .usWest2, identityPoolId:"us-west-2:75a728a0-8519-460c-a36c-569b403346e5")
    let configuration = AWSServiceConfiguration(region: .usWest2, credentialsProvider: credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
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
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    if notificationSettings.types != UIUserNotificationType() {
      application.registerForRemoteNotifications()
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
    var token = ""
    
    for i in 0..<deviceToken.count {
      token += String(format: "%02.2hhx", arguments: [chars[i]])
    }
    
    print("Registration succeeded!")
    print("Token: ", token)
    let url = URL(string: "http://67.171.192.151:3000/register?token=\(token)&type=ios")!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
      if let error = error {
        print(error)
      }
      else {
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
        if let error = json["error"] {
          print(error)
        }
        else {
          AppDelegate.endpointArn = json["endpointArn"] as! String
          print ("Successfully registered device with AWS")
        }
      }
    }
      
    task.resume()
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Registration failed \(error)")
  }
  
  func registerForPushNotifications(_ application: UIApplication) {
    let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
    UIApplication.shared.registerUserNotificationSettings(notificationSettings)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let aps = userInfo["aps"] as! [String: AnyObject]
    print (aps)
    if (aps["content-available"] as? Int) == 1 {
      print ("Silent notification")
      if let data = aps["data"] as? [String: AnyObject] {
        print(data)
        window?.rootViewController?.updateInformation(with: data)
        completionHandler(.newData)
      }
      else {
        completionHandler(.noData)
      }
    }
    else {
      completionHandler(.noData)
    }
  }
}

