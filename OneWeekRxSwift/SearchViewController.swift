//
//  SearchViewController.swift
//  OneWeekRxSwift
//
//  Created by Chun Yi Kuo on 2026/6/13.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindSearch()
    }
    
    private func bindSearch() {
        searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.count >= 2 }
            .flatMapLatest { [weak self] keyword -> Observable<[String]> in
                guard let self else {
                    return Observable.just([])
                }
                return self.search(keyword: keyword)
            }
            .map { results in
                results.joined(separator: "\n")
            }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        }
    
    private func search(keyword: String) -> Observable<[String]> {
//        let results = [
//            "\(keyword) result 1",
//            "\(keyword) result 2",
//            "\(keyword) result 3"
//        ]
        let allItems = [
            "Apple",
            "Banana",
            "Cherry",
            "Orange",
            "Grape",
            "Pineapple",
            "Watermelon",
            "Strawberry",
            "Blueberry",
            "Blackberry"
        ]
        let results = allItems.filter { item in
            item.lowercased().contains(keyword.lowercased())
        }
        
        return Observable.just(results)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
