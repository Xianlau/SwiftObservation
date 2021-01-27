###为了减少通知的使用, 提高代码的聚合, 用swift 写的一个事件订阅分发器.
- 支持cocoapods        `pod 'SwiftObservation'`

- 具体说明 https://www.jianshu.com/p/484280dc3a74

##用法案例:
```
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

```

##被观察的对象: `ObserverManager`
```

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

```

## License

SwiftObservation is available under the MIT license. See the LICENSE file for more info.
