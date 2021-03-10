//
//  Model.swift
//  dailydota2
//
//  Created by Dao Duy Duong on 6/4/15.
//  Copyright (c) 2015 Nover. All rights reserved.
//

import Foundation
import ObjectMapper

class Model: NSObject, Mappable, NSCopying {
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {}
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Model(JSON: [String: Any]())!
    }
    
}

struct ExpandedCellData {
    var isOpen = false
    var title = String()
    var sectionData = [Model]()
}







