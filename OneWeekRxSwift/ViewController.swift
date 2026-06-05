//
//  ViewController.swift
//  OneWeekRxSwift
//
//  Created by David Kuo on 2026/6/5.
//

import UIKit
import RxSwift

/// Day 1

// DisposeBag：管理訂閱生命週期
let disposeBag = DisposeBag()

// Observable：事件來源
let observable = Observable.of("Apple", "Banana", "Cherry")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe：監聽事件
        observable
            .subscribe(onNext: { value in
                print("收到：\(value)")
            }, onCompleted: {
                print("完成")
            })
            .disposed(by: disposeBag)
    }


}

