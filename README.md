# OneWeekRxSwift
A showcase of a week's worth of RxSwift learning content scheduled by AI

## RxSwift

Github: https://github.com/ReactiveX/RxSwift

記得透過 Swift Package Manager 安裝 

## Day 1：先理解 RxSwift 在解決什麼問題

RxSwift 是把「事件」包裝成一條可以被觀察、轉換、訂閱的資料流。

例如：
按鈕點擊
文字輸入
API 回傳
Timer 每秒觸發
Notification 發生

這些都可以被 RxSwift 視為事件流。


### 觀念

1. Observable

Observable 是「會發出事件的東西」。

例如：
```
let numbers = Observable.of(1, 2, 3)
```
它會發出：
```
next(1)
next(2)
next(3)
completed
```

2. Subscribe

subscribe 是「監聽這條資料流」。
```
numbers.subscribe(onNext: { value in
    print(value)
})
```
意思是：
每當 Observable 發出一個值，我就執行一次 closure。

3. DisposeBag

RxSwift 的訂閱需要被管理，不然可能造成記憶體問題。

常見寫法：
```
let disposeBag = DisposeBag()

numbers
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)
```

你可以先把 DisposeBag 理解成：

>用來收納訂閱，當物件釋放時，一起取消訂閱。

在 UIViewController 裡通常會這樣寫：
```
class ViewController: UIViewController {
    let disposeBag = DisposeBag()
}
```
### 實作
本日實作內容位於：**ViewController.swift**

## Day 2：理解事件流的轉換：map、filter、compactMap

RxSwift 最重要的特色：

>資料流可以被轉換。

RxSwift 很多時候不是在「直接執行某件事」，而是在描述：

>當事件發生時，資料要怎麼流動、怎麼轉換、最後誰接收。

例如：
```
let numbers = [1, 2, 3, 4, 5]

let result = numbers
    .filter { $0 > 2 }
    .map { $0 * 10 }
```

### 觀念

1. map
把發出的值轉換成另一種形式。
```
Observable.of(1, 2, 3)
    .map { $0 * 10 }
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)
```

結果：
```
10
20
30
```

2. filter
只讓符合條件的值通過。
```
Observable.of(1, 2, 3, 4, 5)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)
```

結果：
```
2
4
```

3. compactMap
把 optional 轉成非 optional，並過濾掉 nil。
```
Observable.of("1", "abc", "3")
    .compactMap { Int($0) }
    .subscribe(onNext: { value in
        print(value)
    })
    .disposed(by: disposeBag)
```

結果：
```
1
3
```

### 實作
本日實作內容位於：**ViewController.swift**
