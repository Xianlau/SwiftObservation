//
//  ObserverManager.swift
//  SwiftObserver_Example
//
//  Created by sam   on 2021/1/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import SwiftObservation

class ObserverManager {
    
    static let shared = ObserverManager.init()
    
    ///名称subject 用来发布事件
    private let nameSubject = BehaviorSubject<String>(value: "zhangsan") {
        print("我被销毁啦")
    }
    ///年龄subject 用来发布事件
    private let ageSubject = BehaviorSubject<UInt>(value: 15)
    
    ///名称获取
    public static var name : String {
        return shared.nameSubject.value
    }
    ///年龄获取
    public static var age : UInt {
        return shared.ageSubject.value
    }
    
    ///名称可监听实例 用来给外界监听
    public static var nameEvent: Observable<String> {
        return shared.nameSubject.asObservable()
    }
    
    ///年龄可监听实例 用来给外界监听
    public static var ageEvent: Observable<UInt> {
        return shared.ageSubject.asObservable()
    }

    
    ///发布名称改变的事件
    public static func publishNameEvent(value: String) {
        if value != shared.nameSubject.value {
            shared.nameSubject.publish(value)
        }
    }
    
    ///发布年龄改变的事件
    public static func publishAgeEvent(value: UInt) {
        if value != shared.ageSubject.value {
            shared.ageSubject.publish(value)
        }
    }
}
