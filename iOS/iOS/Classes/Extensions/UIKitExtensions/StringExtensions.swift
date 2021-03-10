//
//  StringExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension String {
    
    // create URL
    var url: URL? {
        return URL(string: self)
    }
    
    // create URLRequest
    var urlRequest: URLRequest? {
        if let url = url {
            return URLRequest(url: url)
        }
        return nil
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var escapeHtml: String {
        return self.replacingOccurrences(of: "</br>", with: "\n")
    }
    
    var toHtmlFormat: String {
        return "<!DOCTYPE html><html><head><meta charset=\"utf-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0\"></head><body>\(self)</body><script type=\"text/javascript\"> document.body.style.webkitTouchCallout='none'; document.body.style.background=\"transparent\";</script></html>"
    }
    
    func removeHTMLTag() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
}




