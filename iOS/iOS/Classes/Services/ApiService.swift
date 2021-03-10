//
//  DataManager.swift
//  StupidLazy
//
//  Created by ToaNT1 on 1/4/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import RxSwift
import RxCocoa

protocol INetworkService {
    
    func login(_ name: String, _ password: String) -> Observable<LoginResponse?>
    
}

class ApiService: NetworkService,INetworkService  {
    
    private var tmpBag: DisposeBag!
    
    deinit {
        tmpBag = nil
    }
    
    //MARK: Login
    func login(_ name: String, _ password: String) -> Observable<LoginResponse?> {
        return post(withAction: SoapAction.login, body: SoapBody.login(name, password))
            .subscribeOn(scheduler.backgroundScheduler)
            .map{ jsonString in
                if let response = LoginResponse(JSONString: jsonString) {
                    if let user = response.user {
                        dataManager.varUser.accept(user)
                    }
                    return response
                }
                
                return nil
        }
    }
    
}
