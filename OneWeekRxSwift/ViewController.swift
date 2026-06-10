//
//  ViewController.swift
//  OneWeekRxSwift
//
//  Created by David Kuo on 2026/6/5.
//

import UIKit
import RxSwift
import RxCocoa

/// Day 1

// DisposeBag：管理訂閱生命週期
let disposeBag = DisposeBag()

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        day1()
        
//        day2()
        
        // day3
        bindUI()
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
    
    private func bindUI() {
        textField.rx.text
            .orEmpty
            .map { "你輸入的是：\($0)" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.textField.text = ""
                self?.resultLabel.text = "請輸入文字"
            })
            .disposed(by: disposeBag)
    }

}

