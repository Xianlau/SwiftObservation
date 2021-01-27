//
//  Subject.swift
//  SwiftObserver
//
//  Created by sam   on 2021/1/27.
//

import Foundation

/// 只发布内容，但不缓存内容
public class PublishSubject<Value>: Observable<Value> {
    
    ///转成可观察对象
    public func asObservable() -> Observable<Value> {
        return self
    }
    
    ///发布新事件
    public func publish(_ value: Value) {
        notifyObserverArr(value)
    }
}

/// 发布内容，同时也缓存最新内容
public class BehaviorSubject<Value>: PublishSubject<Value> {
    
    private var _value: Value
    
    public var value: Value {
        return _value
    }
    
    
    ///初始化, onDispose: 销毁的时候执行的闭包
    public init(value: Value, onDispose: @escaping () -> Void = {}) {
        _value = value
        super.init(onDispose)
    }
    
    ///发布新事件
    public override func publish(_ value: Value) {
        _value = value
        super.publish(_value)
    }
}
