//
//  CommonItem.swift
//  DolEnglish
//
//  Created by ToaNT1 on 10/15/18.
//  Copyright © 2018 appteamvn. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift

class PickerItem: Model {
    
    var title = ""
    var value = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- (map["title"])
        value <- (map["value"])
    }
    
    convenience init(with title: String, value: String) {
        self.init(JSON: ["title": title, "value": title])!
    }
    
    
}
