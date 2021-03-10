//
//  NSErrorExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension NSError {
    
    static var Domain: String {
        return ""
    }
    
    static var unknownError: NSError {
        return NSError(domain: Domain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Có lỗi xảy ra. Vui lòng thử lại sau!"])
    }
    
    static func faultError(_ msg: String) -> NSError {
        return NSError(domain: Domain, code: 1001, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func permissionError(_ msg: String) -> NSError {
        return NSError(domain: Domain, code: 401, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var connectionError: NSError {
        return NSError(domain: Domain, code: 3, userInfo: [NSLocalizedDescriptionKey: "Không có kết nối internet"])
    }
    
    static var URLNotFoundError: NSError {
        return NSError(domain: Domain, code: 6, userInfo: [NSLocalizedDescriptionKey: "Không tìm thấy đường dẫn."])
    }
}









