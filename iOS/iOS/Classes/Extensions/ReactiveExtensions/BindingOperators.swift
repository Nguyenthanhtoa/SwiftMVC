//
//  BindingOperators.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Two way binding shorthand

infix operator <~> : DefaultPrecedence

func <~><T>(property: ControlProperty<T>, BehaviorRelay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = BehaviorRelay.asObservable().bind(to: property)
    let bindToBehaviorRelay = property.subscribe(
        onNext: { value in BehaviorRelay.accept(value) },
        onCompleted: { bindToUIDisposable.dispose() }
    )
    
    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}

func <~><T>(BehaviorRelay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let bindToUIDisposable = BehaviorRelay.asObservable().bind(to: property)
    let bindToBehaviorRelay = property.bind(to: BehaviorRelay)
    
    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

func ~><T>(source: Observable<T>, observer: AnyObserver<T>) -> Disposable {
    return source.bind(to: observer)
}

func ~><T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
    return source.bind(to: binder)
}

func ~><T>(source: Observable<T>, observer: Binder<T>) -> Disposable {
    return source.bind(to: observer.asObserver())
}

func ~><T>(source: Observable<T>, BehaviorRelay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: BehaviorRelay)
}

func ~><T>(source: Observable<T>, BehaviorRelay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: BehaviorRelay)
}

func ~><T>(source: Observable<T>, binder: ControlProperty<T>) -> Disposable {
    return source.subscribe(onNext: { binder.onNext($0) })
}

func ~><T>(source: Observable<T>, binder: PublishSubject<T>) -> Disposable {
    return source.bind(to: binder.asObserver())
}

func ~><T>(BehaviorRelay: BehaviorRelay<T>, observer: AnyObserver<T>) -> Disposable {
    return BehaviorRelay.asObservable().bind(to: observer)
}

func ~><T>(BehaviorRelay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
    return BehaviorRelay.asObservable().bind(to: observer.asObserver())
}

func ~><T>(event: ControlEvent<T>, BehaviorRelay: BehaviorRelay<T>) -> Disposable {
    return event.bind(to: BehaviorRelay)
}

// MARK: - Add to dispose bag shorthand

precedencegroup DisposablePrecedence {
    lowerThan: DefaultPrecedence
}

infix operator =>: DisposablePrecedence

func =>(disposable: Disposable?, bag: DisposeBag) {
    disposable?.disposed(by: bag)
}


















