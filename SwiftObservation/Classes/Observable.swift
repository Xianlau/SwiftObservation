//
//  Observable.swift
//  SwiftObserver
//
//  Created by sam   on 2021/1/27.
//

import Foundation

/*
 *一个可以观察的对象
 *
 */
public class Observable<Value> {
    
    ///观察者, 就是一个闭包, 事件发布的时候触发
    public typealias Observer = (Value) -> Void
    
    //序列的迭代器
    private var uniqueId = (0...).makeIterator()
    //递归锁
    private let lock = NSRecursiveLock()
    //销毁的时候执行的闭包
    private var onDispose: () -> Void
    
    //观察者数组
    fileprivate var observerArr: [Int : (Observer, DispatchQueue)] = [:]
    
    
    // onDispose: 销毁的时候执行的闭包
    init(_ onDispose: @escaping () -> Void = {}) {
        self.onDispose = onDispose
    }
    
    /*
     *  事件的订阅函数, 返回一个可以销毁的对象
     *  - observer: 观察者, 就是一个闭包, 事件发布的时候触发
     *  - queue: 在指定的线程里面执行闭包
     */
    public func subscribe(observer: @escaping Observer, on queue: DispatchQueue = .main) -> Disposable {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let id = uniqueId.next()!
        observerArr[id] = (observer, queue)
        
        //订阅执行完后, 返回一个销毁的对象, 用来销毁自身的观察者, 以及执行销毁后的闭包
        let disposable = Disposable.init { [weak self] in
            self?.observerArr[id] = nil
            self?.onDispose()
        }
        return disposable
    }
    
}


extension Observable {
    
    //有新的事件, 通知所有观察者
    func notifyObserverArr(_ value: Value) {
        observerArr.forEach {
            let observer = $0.value.0
            let queue = $0.value.1
            if isCurrentQueue(queue) {
                observer(value)
            } else {
                queue.async { observer(value) }
            }
        }

    }
    
    //判断是否当前线程
    private func isCurrentQueue(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<UInt32>()
        queue.setSpecific(key: key, value: arc4random())
        defer { queue.setSpecific(key: key, value: nil) }
        
        return DispatchQueue.getSpecific(key: key) != nil
    }
}
