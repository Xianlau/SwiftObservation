//
//  ViewController.swift
//  SwiftObservation
//
//  Created by xianlau on 01/27/2021.
//  Copyright (c) 2021 xianlau. All rights reserved.
//

import UIKit
import SwiftObservation


class ViewController: UIViewController {
    
    let disposebag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //名称事件有更新
        ObserverManager.nameEvent.subscribe { (name) in
            print(name)
        }.dispose(by: disposebag)
        
        //年龄事件有更新
        ObserverManager.ageEvent.subscribe { (age) in
            print(age)
        }.dispose(by: disposebag)
        
        //更改名称
        ObserverManager.publishNameEvent(value: "liuweixiang")
        //更改年龄
        ObserverManager.publishAgeEvent(value: 18)
    }


}

