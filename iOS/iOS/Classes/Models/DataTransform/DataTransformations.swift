//
//  DataTransformation.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 2/4/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import ObjectMapper

internal class URLTransform: TransformType {
    
    public typealias Object = URL
    public typealias JSON = String
    
    internal func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? JSON {
            if value.hasPrefix("http://") || value.hasPrefix("https://") {
                return URL(string: value)
            } else if value.hasPrefix("//") {
                return URL(string: "https:" + value)
            } else {
                let urlString = "\(Api.endpointResource)\(value)"
                return URL(string: urlString)
            }
        }
        return nil
    }
    
    open func transformToJSON(_ value: Object?) -> JSON? {
        return value?.absoluteString
    }
    
}



