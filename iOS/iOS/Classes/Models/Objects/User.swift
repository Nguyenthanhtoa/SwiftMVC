//
//  DataManager.swift
//  StupidLazy
//
//  Created by ToaNT1 on 1/4/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import RxSwift
import ObjectMapper

class User: Model {
    
    var id: Int?
    var userName = ""
    var email = ""
    var firstName = ""
    
    var lastName = ""
    var phone = ""
    var address = ""
    var birthday = Date()
    
    var gender = 0
    
    convenience init() {
        self.init(JSON: [String: Any]())!
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- (map["ID"])
        userName <- (map["Username"])
        email <- (map["Email"])
        firstName <- (map["FirstName"])
        
        lastName <- (map["LastName"])
        phone <- (map["Phone"])
        address <- (map["Address"])
        birthday <- (map["BirthDay"], ISO8601DateTransform())
        
        gender <- (map["Gender"])
    }
    
}

class LoginResponse: BaseResponse {
    
    var user: User?
    
    convenience required public init() {
        self.init(JSON: [String: Any]())!
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        user <- (map["Account"])
    }
}

