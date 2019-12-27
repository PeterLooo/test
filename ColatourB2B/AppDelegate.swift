//
//  AppDelegate.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import FirebaseInstanceID
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var disposebag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setFirebaseNotification(application)
        return true
    }
    
    private func setFirebaseNotification(_ application: UIApplication) {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { (granted, error) in
                self.pushDevice()
                
        })
        
        UNUserNotificationCenter.current().delegate = self
        
    
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
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


}

extension AppDelegate: MessagingDelegate {
    // Receive data message on iOS 10 devices.
    func application(received remoteMessage: MessagingRemoteMessage) {
        printLog("received remoteMessage", "")
        printLog("received:%@", remoteMessage.appData)
    }
    
    // Note : To be notified whenever the token is updated, supply a delegate conforming to the messaging delegate protocol. The following example registers the delegate and adds the proper delegate method:
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        printLog("Firebase registration token", fcmToken)
        AccountRepository.shared.procressFirebaseToken(firebaseToken: fcmToken)
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        pushDevice()
        connectToFcm()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        self.printLog("Refresh fcmToken", fcmToken)
        
        AccountRepository.shared.procressFirebaseToken(firebaseToken: fcmToken)
        
        pushDevice()
    }
    
    private func pushDevice() {
        if UserDefaultUtil.shared.firebaseToken == nil { return }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .authorized:
//                AccountRepository
//                    .shared
//                    .pushDevice()
//                    .subscribe()
//                    .disposed(by: self.disposebag)
                ()
            default:
                ()
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    // 收到推播
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        // Print full message.
        printLog("===willPresent===", "")
        if let aps = (userInfo["aps"] as? NSDictionary) {
            if let badgeNumber = aps["badge"] as? Int {
                UIApplication.shared.applicationIconBadgeNumber = badgeNumber
            }
        }
        
        completionHandler(.alert)
    }
    
    // User tap Notification will be in here
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        #warning("推播點擊後事件 待測試")
        let userInfo = response.notification.request.content.userInfo
        printLog("===didReceive===", "")
        printLog("userInfo", userInfo)
        
        
        var linkType: LinkType = .unknown
        if let index = userInfo.index(forKey: "Link_Type") {
            linkType = LinkType(rawValue: userInfo[index].value as! String) ?? .unknown
        }
        
        if linkType == .unknown {
            completionHandler()
            return
        }
        
        var linkParams = ""
        if let index = userInfo.index(forKey: "Link_Params") {
            linkParams = userInfo[index].value as! String
        }
        
        let vc = ShareFunc.getVC(st: "Main", vc: "TabBarController") as! TabBarViewController
        vc.view.layoutIfNeeded()
        
        let navigationController = (vc.selectedViewController) as! UINavigationController
        let presentingViewController = navigationController.viewControllers.last
        let baseViewController = (presentingViewController as! BaseViewController)
        baseViewController.handleLinkType(linkType: linkType, linkValue: linkParams, linkText: "")
        
        
        UIView.transition(with: appDelegate!.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            appDelegate?.window?.rootViewController = vc
        })
        
        completionHandler()
    }
    
}
extension AppDelegate {
    func connectToFcm() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    private func printFireBaseToken(_ granted: Bool, _ error: Error?) {
        #if DEBUG
        printLog("granted", granted)
        if ((error) != nil) {
            printLog("firebase_error", error!)
        }
        #endif
    }
    
    private func printLog(_ title: String, _ value: Any?) {
        #if DEBUG
        print("* \(title) : ")
        if let v = value {
            print("   \(v)")
        } else {
            print("   nil")
        }
        #endif
    }
}
