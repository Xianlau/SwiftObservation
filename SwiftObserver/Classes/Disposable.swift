//
//  Disposable.swift
//  SwiftObserver
//
//  Created by sam   on 2021/1/27.
//

import Foundation

/*
 *一个用于提供销毁资源的实例.
 *把自身添加到DisposeBag里, DisposeBag在销毁的时候, 会顺便把此对象销毁.
 */
public final class Disposable {
    
    ///销毁后执行的闭包
    let dispose: () -> Void
    
    public init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
    
    ///把自身添加到DisposeBag里, DisposeBag在销毁的时候, 会顺便把此对象销毁
    public func dispose(by disposeBag: DisposeBag) {
        disposeBag.add(self)
    }
}


/*
 *管理'disposableArr'的销毁, 自身销毁后, 所有的'disposableArr'也会销毁
 *
 */
public final class DisposeBag {
    
    private let lock: NSRecursiveLock = NSRecursiveLock()
    private var disposableArr: [Disposable] = [Disposable]()
    private var isDisposed = false

    public init() {
        
    }
    
    deinit {
        dispose()
    }

    /// 添加一个需要销毁的资源
    public func add(_ disposable: Disposable) {
        lock.lock()
        defer { lock.unlock() }
        
        if isDisposed { return }
        disposableArr.append(disposable)
    }
    
    //移除所有Disposable
    private func removeDisposableArr() -> [Disposable] {
        lock.lock()
        defer { lock.unlock() }

        let disposableARR = self.disposableArr
        self.disposableArr.removeAll(keepingCapacity: false)
        self.isDisposed = true
        
        return disposableARR
    }
    
    //销毁所有的Disable对象
    private func dispose() {
        let disposableARR = removeDisposableArr()
        //执行每个Disable销毁前的闭包
        for disposable in disposableARR {
            disposable.dispose()
        }
    }
}
