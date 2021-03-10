//
//  NavigationUtil.swift
//  phimbo
//
//  Created by Dao Duy Duong on 7/27/17.
//  Copyright © 2017 Nover. All rights reserved.
//

import UIKit
import RxSwift

enum PushType {
    case auto, push, modally
}

enum PopType {
    case auto, pop, dismiss, root
}

// MARK: - Navigation cores

class NavigationUtil {
    
    fileprivate static var appDelegate = UIApplication.shared.delegate as! AppDelegate

    fileprivate static var tmpBag: DisposeBag! {
        return DisposeBag()
    }
    
    fileprivate static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    fileprivate static var rootPage: UIViewController? {
        get { return keyWindow?.rootViewController }
        set { keyWindow?.rootViewController = newValue }
    }
    
    fileprivate static var appRootPage: UIViewController? {
        return getTopMostController()
    }
    
    fileprivate static var topPage: UIViewController? {
        if let rootPage = appRootPage {
            var currPage: UIViewController? = rootPage.presentedViewController ?? rootPage
            
            while currPage?.presentedViewController != nil {
                currPage = currPage?.presentedViewController
            }
            
            while currPage is UINavigationController || currPage is UITabBarController {
                if currPage is UINavigationController {
                    currPage = (currPage as? UINavigationController)?.viewControllers.last
                }
                
                if currPage is UITabBarController {
                    currPage = (currPage as? UITabBarController)?.selectedViewController
                }
            }
            
            return currPage
        }
        
        return nil
    }
    
    static func replaceRootPageWithPage(_ page: UIViewController) {
        if let rootPage = self.rootPage {
            destroyPage(rootPage)
        }
        
        self.rootPage = page
    }
    
    fileprivate static func destroyPage(_ page: UIViewController?) {
        var viewControllers = [UIViewController]()
        if page is UINavigationController {
            viewControllers = (page as! UINavigationController).viewControllers
        }
        
        if page is UITabBarController {
            viewControllers = (page as! UITabBarController).viewControllers ?? []
        }
        
        viewControllers.forEach { ($0 as? Destroyable)?.destroy() }
        (page as? Destroyable)?.destroy()
    }
    
    // MARK: Get top view controller
    static func getTopMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        
        return topController
    }
}

// MARK: - Main navigations

extension NavigationUtil {
    
    static func pop(usingType type: PopType = .auto, animated: Bool = true) {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: true) { poppedPage in
                    self.destroyPage(poppedPage)
                }
            } else {
                if let navPage = topPage.navigationController {
                    navPage.dismiss(animated: animated, completion: {
                        destroyPage(topPage)
                    })
                } else {
                    topPage.dismiss(animated: animated) {
                        destroyPage(topPage)
                    }
                }
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: true) { poppedPage in
                self.destroyPage(poppedPage)
            }
            
        case .dismiss:
            if let navPage = topPage.navigationController {
                navPage.dismiss(animated: animated, completion: {
                    destroyPage(topPage)
                })
            } else {
                topPage.dismiss(animated: animated) {
                    destroyPage(topPage)
                }
            }
            
        case .root:
            if let navPage = topPage.navigationController {
                navPage.popToRootViewController(animated: animated)
            }
        }
    }
    
    static func push(toPage page: UIViewController, usingType type: PushType = .auto, animated: Bool = true, backTitle: String = "Back") {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                let backBtn = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
                topPage.navigationItem.backBarButtonItem = backBtn
                
                navPage.pushViewController(page, animated: animated)
            } else {
                topPage.present(page, animated: animated, completion: nil)
            }
            
        case .push:
            let backBtn = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
            topPage.navigationItem.backBarButtonItem = backBtn
            
            topPage.navigationController?.pushViewController(page, animated: animated)
            
        case .modally:
            topPage.present(page, animated: animated, completion: nil)
        }
    }
    
    static func popup(toPage page: UIViewController) {
        guard let topPage = topPage else { return }
        topPage.present(page, animated: true, completion: nil)
    }
    
    //MARK: open specific url
    static func openURL(_ url: String) -> Observable<Bool> {
        return Observable.create { observer in
            
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            
            return Disposables.create { }
        }
    }
    
    //MARK: open specific url
    static func endEditting(){
        guard let topPage = topPage else { return }
        topPage.view.endEditing(true)
    }
    
}

// MARK: - Extension for NavigationUtil to login facebook
extension NavigationUtil {
    
    static func showLogin() {
        NavigationUtil.replaceRootPageWithPage(appDelegate.loginPage)
    }

    //MARK: open App Settings
    static func openAppSetting() {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: Open internal webpage
    static func navigateToWebPage(url: URL, title: String) {
        NavigationUtil.pop(usingType: .root, animated: false)
    }
}









