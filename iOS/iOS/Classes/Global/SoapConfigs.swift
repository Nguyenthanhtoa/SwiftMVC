//
//  DataManager.swift
//  StupidLazy
//
//  Created by ToaNT1 on 1/4/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import Foundation

struct SoapAction {
    
    static let login = "http://tempuri.org/Login"
    
}

struct SoapBody {
    
    // Login
    static func login(_ userName: String, _ password: String) -> String {
        let platformType = 2 // 2 is IOS
        let platformTypeName = "iOS"
        let deviceToken = dataManager.varFCMToken.value ?? ""
        
        return "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><Login xmlns=\"http://tempuri.org/\"><Username>\(userName)</Username><Password>\(password)</Password><Type>\(platformType)</Type><DeviceToken>\(deviceToken)</DeviceToken><TypeName>\(platformTypeName)</TypeName></Login></soap:Body></soap:Envelope>"
    }
}




