//
//  Protocols.swift
//  phimbo
//
//  Created by Dao Duy Duong on 8/29/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import RxSwift

protocol Destroyable: class {
    var disposeBag: DisposeBag! { get set }
    func destroy()
}

protocol GenericPage: Destroyable {
    associatedtype ViewModelElement
    
    var viewModel: ViewModelElement! { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

protocol CollectionPage {
    var collectionView: UICollectionView! { get }
    var layout: UICollectionViewLayout! { get }
}

protocol TablePage {
    var tableView: UITableView! { get }
}









