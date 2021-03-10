//
//  Scheduler.swift
//  HealthCare
//
//  Created by Dao Duy Duong on 11/5/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Scheduler {
    
    static let sharedScheduler = Scheduler()
    static let loadingTimeout: Double = 30

    let backgroundScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    let mainQueue = DispatchQueue.main

    init() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        
        backgroundScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        mainScheduler = MainScheduler.instance
    }
    
}
