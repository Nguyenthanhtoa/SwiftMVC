//
//  DataManager.swift
//  StupidLazy
//
//  Created by ToaNT1 on 1/4/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Alamofire
import Toaster

let kUser = "user"
let kToken = "fcmtoken"
let kLogin = "login"

class DataManager {
    
    typealias ReachabilityStatus = NetworkReachabilityManager.NetworkReachabilityStatus
    fileprivate var networkReachabilityManager: NetworkReachabilityManager!
    
    fileprivate var disposeBag: DisposeBag!
    static let shared = DataManager()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let varConnected = BehaviorRelay(value: false)
    let varState = BehaviorRelay<ApplicationState>(value: .none)
    
    let varIsLoaded = BehaviorRelay(value: false)
    let service = ApiService()
    let varUser = BehaviorRelay<User?>(value: nil)
    let defaults = UserDefaults.standard
    let varCanPush = BehaviorRelay(value: true)
    
    // Push
    var varFCMToken = BehaviorRelay<String?>(value: nil)
    
    var uid: Int {
        return varUser.value == nil ? 0 : varUser.value!.id ?? 0
    }
    
    init() {
        networkReachabilityManager = NetworkReachabilityManager(host: internetHost)
        networkReachabilityManager?.listener = networkStatusListener
        networkReachabilityManager?.startListening()
    }
    
    func initialize() {
        disposeBag = DisposeBag()
        retrieveUser()
        
        varConnected.asObservable()
            .filter{ $0 }
            .subscribe(onNext: {_ in self.loadAllComponent() }) => disposeBag
        
        dataManager.varConnected
            .asObservable()
            .skip(1)
            .subscribe(onNext: { isConnected in
                if !isConnected {
                    self.showToast("Không có kết nối internet")
                }
                
                print(isConnected ? "internet connected" : "internet NOT connected")
            }) => disposeBag
        
        varUser.asObservable()
            .filterNil()
            .subscribe(onNext: storeUser) => disposeBag
    }
    
    //MARK: Load all component
    func loadAllComponent() {
    }
    
    // MARK: Toast
    func showToast(_ message: String = "") {
        ToastCenter.default.cancelAll()
        Toast(text: message).show()
    }
    
}

//MARK: Load data
extension DataManager {
    
}

//MARK: Utils for DataManager
extension DataManager {
    
    fileprivate func networkStatusListener(_ status: ReachabilityStatus) {
        varConnected.accept(status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan))
    }
    
    func isConnected() -> Bool {
        let connected = networkReachabilityManager.isReachable
        
        if !connected {
            AlertView.presentNoConnectionAlert()
        }
        
        return connected
    }
    
    func clearUp() {
        disposeBag = nil
    }
    
    //MARK: Store user using user default
    func storeUser(usr: User) {
        defaults.setValue(usr.toJSON(), forKey: kUser)
    }
    
    func retrieveUser() {
        if let json = defaults.value(forKey: kUser) {
            varUser.accept(User(JSON: json as! [String: Any]))
        }
    }
    
    //MARK: Store token
    func storeToken(_ token: String) {
        defaults.setValue(token, forKey: kToken)
    }
    
    func retriveToken() -> String? {
        return defaults.string(forKey: kToken) ?? nil
    }
    
    //MARK: Store remember login
    func storeLogin() {
        defaults.setValue(true, forKey: kLogin)
    }
    
    func retrieveLogin() -> Bool {
        if let isRemmber = defaults.value(forKey: kLogin) {
            return isRemmber as! Bool
        }
        return false
    }
    
    func logout() {
        varUser.accept(nil)
        defaults.removeObject(forKey: kUser)
        defaults.removeObject(forKey: kLogin)
    }
    
}



