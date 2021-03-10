//
//  PListServices.swift
//  VivoTV
//
//  Created by ThanhToa on 12/30/17.
//  Copyright © 2017 ToaNT1. All rights reserved.
//

import Foundation
import ObjectMapper

class PListService {

    // MARK: Get product category items
    static func loadProductCategory() -> [Model] {
        if let path = Bundle.main.path(forResource: "category", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [[String : Any]] {
                return Mapper<Model>().mapArray(JSONArray: array)
            }
        }
        return []
    }
    
}
