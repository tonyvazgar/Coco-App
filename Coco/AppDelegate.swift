//
//  AppDelegate.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FBSDKCoreKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var gcmMessageIDKey = "gcm.message_id"
    let signInConfig = GIDConfiguration.init(clientID: "4899968219-36j7srntqp2s2ec37kjvk3r523ik817b.apps.googleusercontent.com")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    UserDefaults.standard.set(true, forKey: "showedPromo")
    
    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    
    FirebaseApp.configure()
      Settings.isAdvertiserIDCollectionEnabled = true
    Settings.isAutoLogAppEventsEnabled = true
    Settings.setAdvertiserTrackingEnabled(true)
    Settings.isAdvertiserIDCollectionEnabled = true
    Messaging.messaging().delegate = self
      if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }

      application.registerForRemoteNotifications()
      
    
    IQKeyboardManager.shared.enable = true
    
    let initialViewController: UIViewController
    let defaults = UserDefaults.standard

    if defaults.object(forKey: "primeraVez") == nil {
        defaults.set("No", forKey:"primeraVez")
        initialViewController = UIStoryboard.banner.instantiate(BannerViewController.self)
    }else{
        if let _ = UserManagement.shared.id_user {
            initialViewController = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
        } else {
            initialViewController = UIStoryboard.accounts.instantiate(TiposLogInViewController.self)
        }
    }
    
    let navigationController = UINavigationController(rootViewController: initialViewController)
    navigationController.setNavigationBarHidden(true, animated: false)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    
    return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    /*let isFBOpenUrl = ApplicationDelegate.shared.application(app,
                                                             open: url,
                                                             sourceApplication: options[.sourceApplication] as? String,
                                                             annotation: options[.annotation])
    if isFBOpenUrl { return true }
    */
      return GIDSignIn.sharedInstance.handle(url) ?? false
    //return false
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
    NotificationCenter.default.post(name: Notification.Name(rawValue: "showPopUp"), object: nil)
    NotificationCenter.default.post(name: Notification.Name("anotherGift"), object: nil)
    NotificationCenter.default.post(name: Notification.Name("getMoreTime"), object: nil)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

          // Print full message.
          print("Notification 1")
          print(userInfo)
        }
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          // With swizzling disabled you must let Messaging know about the message, for Analytics
          // Messaging.messaging().appDidReceiveMessage(userInfo)
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

          // Print full message.
            print("Notification 2")
          print(userInfo)

          completionHandler(UIBackgroundFetchResult.newData)
        }
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          print("Unable to register for remote notifications: \(error.localizedDescription)")
        }

        // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
        // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
        // the FCM registration token.
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          print("APNs token retrieved: \(deviceToken)")

          // With swizzling disabled you must set the APNs token here.
          // Messaging.messaging().apnsToken = deviceToken
        }
  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "Coco")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
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
              fatalError("Unresolved error \(error), \(error.userInfo)")
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

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("Firebase registration token: \(fcmToken ?? "")")
            Messaging.messaging().subscribe(toTopic: "all") { error in
              print("Subscribed to all topic")
            }
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
   
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("notification7")
    }
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print("Notification 4")
        print(userInfo)

        // Change this to your preferred presentation option
       if UIApplication.shared.applicationState == .active { // In iOS 10 if app is in foreground do nothing.
           completionHandler(UNNotificationPresentationOptions.alert)
           completionHandler([])
       } else { // If app is not active you can show banner, sound and badge.
           completionHandler([.alert, .badge, .sound])
       }

      }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
    
}
