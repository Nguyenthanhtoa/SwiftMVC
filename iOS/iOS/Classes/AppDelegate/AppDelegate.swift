//
//  AppDelegate.swift
//  iOS
//
//  Created by ThanhToa on 12/12/18.
//  Copyright © 2018 ThanhToa. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import Toaster
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var loginPage: LoginPage!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registNotification(application)
        styleAppearance()
        initialize()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        dataManager.varState.accept(.resignActive)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        dataManager.varState.accept(.didEnterBackground)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        dataManager.varState.accept(.willEnterForeground)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        dataManager.varState.accept(.didBecomeActive)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataManager.varState.accept(.willTerminate)
    }
    
    // MARK: PUSH
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo.description)
    }
    
    // MARK: - Private
    private func initialize() {
//        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        styleAppearance()
        dataManager.initialize()
        
        loginPage = Util.getPage(fromId: Common.LoginPage)
        
        let isRemember = dataManager.retrieveLogin()        
        if isRemember {
            dataManager.initialize()
        }
        
        window?.rootViewController = loginPage
        window?.makeKeyAndVisible()
    }
    
    private func styleAppearance() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.setBackgroundImage(UIImage.from(color: .primaryColor), for: .default)
        navBarAppearance.tintColor = .white
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.system.bold(withSize: 17)
        ]
        navBarAppearance.shadowImage = UIImage.from(color: .clear)
        
        ToastView.appearance().font = Font.system.bold(withSize: 15)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}
