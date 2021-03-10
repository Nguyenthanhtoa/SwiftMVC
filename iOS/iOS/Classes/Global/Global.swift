//
//  Global.swift
//  mvvm-scaffold
//
//  Created by Dao Duy Duong on 1/18/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import UIKit

let scheduler = Scheduler.sharedScheduler
let dataManager = DataManager.shared

let screenSize = UIScreen.main.bounds
let uid = UUID().uuidString
let isPad = UIDevice.current.userInterfaceIdiom == .pad
let isIPhoneX = screenSize.height >= 812
let internetHost = "google.com"

// MARK: - Global funcs
func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

// MARK: - App icons
struct Image {
    
    static func make(fromName imageNamed: String) -> UIImage? {
        return UIImage(named: imageNamed)
    }
    
    static func make(fromHex hex: String) -> UIImage {
        return UIImage.from(color: .hex(hex))
    }
    
}












