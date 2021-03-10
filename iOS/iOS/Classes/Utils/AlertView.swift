//
//  AlertController.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 3/2/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift

class AlertView: UIAlertController {
    
    var alertWindow: UIWindow? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    func show() {
        showAnimated(true)
    }
    
    func showAnimated(_ animated: Bool) {
        let blankViewController = UIViewController()
        blankViewController.view.backgroundColor = .clear
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = blankViewController
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        alertWindow = window
        
        blankViewController.present(self, animated: animated, completion: nil)
    }
    
    static func presentOkayAlertWithTitle(_ title: String?, message: String?) {
        let alertController = AlertView(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        
        alertController.show()
    }
    
    static func presentConfirmWithTitle(_ title: String?, message: String?, yesText: String = "Có", noText: String = "Không", handler: @escaping ((Bool) -> Void)) {
        
        let alertController = AlertView(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: yesText, style: .default) { _ in
            handler(true)
        }
        let noAction = UIAlertAction(title: noText, style: .cancel) { _ in
            handler(false)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        alertController.show()
        
    }
    
    static func presentConfirmWithTitleObs(_ title: String?, message: String?, yesText: String = "Có", noText: String = "Không") -> Observable<Bool> {
        
        return Observable.create { observer in
            let alertController = AlertView(title: title, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesText, style: .default) { _ in
                observer.onNext(true)
            }
            let noAction = UIAlertAction(title: noText, style: .cancel) { _ in
                observer.onNext(false)
            }
            
            alertController.addAction(noAction)
            alertController.addAction(yesAction)

            alertController.show()
            
            return Disposables.create { }
        }
        
    }
    
    static func presentOkayAlertWithError(_ error: Error) {
        presentOkayAlertWithTitle("Lỗi", message: error.localizedDescription)
    }
    
    static func presentNoConnectionAlert() {
        presentOkayAlertWithError(NSError.connectionError)
    }
}
