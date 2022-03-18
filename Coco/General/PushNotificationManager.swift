//
//  PushNotificationManager.swift
//  Coco
//
//  Created by Carlos Banos on 8/13/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var notification: Notifications!
    var gcmMessageIDKey = "gcm.message_id"
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            UserDefaults.standard.set(token, forKey: "token")
            notification = Notifications()
            if !UserManagement.shared.token_saved {
                UserDefaults.standard.set(true, forKey: "token_saved")
                notification.updateRequest { _ in }
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        completionHandler()
    }
    
    
}
@available(iOS 10, *)
extension PushNotificationManager  {
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
    
}
