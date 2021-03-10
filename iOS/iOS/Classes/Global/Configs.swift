//
//  Configs.swift
//  phimbo
//
//  Created by Dao Duy Duong on 2/24/17.
//  Copyright © 2017 Nover. All rights reserved.
//

import UIKit

enum Environment: String {
    case development = "development"
    case production = "production"
}

struct Api {
    
    static let environment: Environment = .production
    
    static let endpoint = "\(environment.rawValue)/webservice1.asmx"
    static let endpointResource = environment.rawValue
    
}









