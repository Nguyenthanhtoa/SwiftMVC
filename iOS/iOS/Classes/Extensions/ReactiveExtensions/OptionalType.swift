//
//  OptionalType.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol OptionalType {
    
    associatedtype Wrapped
    var value: Wrapped? { get }
    
}

extension Optional: OptionalType {
    
    var value: Wrapped? {
        return self
    }
    
}

extension ObservableType where Element: OptionalType {
    
    func filterNil() -> Observable<Element.Wrapped> {
        return self.filter { $0.value != nil }.map { $0.value! }
    }
    
}
