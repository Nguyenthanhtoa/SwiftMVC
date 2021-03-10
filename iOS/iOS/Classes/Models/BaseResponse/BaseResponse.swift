//
//  CommonResponse.swift
//  SteakBox
//
//  Created by ThanhToa on 4/8/18.
//  Copyright © 2018 ThanhToa. All rights reserved.
//


import Foundation
import ObjectMapper

class BaseResponse: Model {
    
    var code: String?
    var status: String?
    var message: String?

    convenience required public init() {
        self.init(JSON: [String: Any]())!
    }
    
    override public func mapping(map: Map) {
        code <- map["Code"]
        status <- map["Status"]
        message <- map["Message"]
    }
    
    func isSuccess() -> Bool {
        if let st = status {
            return st.lowercased().contains("success")
        }
        return false
    }
}
