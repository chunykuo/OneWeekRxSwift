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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        day1()
        
        day2()
    }

    private func day1() {
        // Observable：事件來源
        let observable = Observable.of("Apple", "Banana", "Cherry")
        
        // Subscribe：監聽事件
        observable
            .subscribe(onNext: { value in
                print("收到：\(value)")
            }, onCompleted: {
                print("完成")
            })
            .disposed(by: disposeBag)
    }
    
    private func day2() {
        let searchText = Observable.of("", "a", "ap", "app", "apple")
        
        searchText
            .filter { !$0.isEmpty }
            .filter { $0.count >= 3 }
            .map { $0.uppercased() }
            .subscribe(onNext: { keyword in
                print("搜尋關鍵字：\(keyword)")
            })
            .disposed(by: disposeBag)
    }

}

