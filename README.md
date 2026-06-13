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


## Day 3：開始接觸 UIKit：RxCocoa、Button、TextField
RxSwift 本身處理 reactive stream，
但和 UIKit 綁定時，通常會搭配：
```
RxCocoa
```

你可以先把 RxCocoa 理解成：

>讓 UIKit 元件可以用 RxSwift 的方式操作。

例如：
```
button.rx.tap
textField.rx.text
label.rx.text
```

今天的重點是你要開始感覺到：

>原本分散在 delegate、target-action、callback 的 UI 行為，可以被整理成一條資料流。

### 觀念
1. button.rx.tap

傳統 UIKit 寫法：
```
button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
```

RxCocoa 寫法：
```
button.rx.tap
    .subscribe(onNext: {
        print("button tapped")
    })
    .disposed(by: disposeBag)
```

2. textField.rx.text

傳統 UIKit 可能會用 delegate 或 target-action 監聽文字變化。

RxCocoa 寫法：
```
textField.rx.text
    .subscribe(onNext: { text in
        print(text)
    })
    .disposed(by: disposeBag)
```

不過 textField.rx.text 的型別通常是 String?，所以常見會搭配：
```
.orEmpty
```

```
textField.rx.text
    .orEmpty
    .subscribe(onNext: { text in
        print(text)
    })
    .disposed(by: disposeBag)
```
這樣就會變成非 optional 的 String。

3. bind

除了 subscribe，RxSwift / RxCocoa 很常看到 bind。

例如把 TextField 的文字綁到 Label：
```
textField.rx.text
    .orEmpty
    .bind(to: label.rx.text)
    .disposed(by: disposeBag)
```
這段意思是：

>textField 文字變化時，自動更新 label 的文字。

### 實作
本日實作內容位於：**ViewController.swift**


## Day 4：理解 Subject、Relay，以及常見 UI 狀態管理

要理解：

>有些事件來源不是 UI 元件，也不是固定資料，而是我們自己主動丟資料進去。

這時候就會用到 Subject 或 Relay。

### 觀念

1. Subject 是什麼？

Subject 同時是：
```
Observable：可以被訂閱
Observer：可以主動送出事件
```

例如：
```
let subject = PublishSubject<String>()

subject
    .subscribe(onNext: { value in
        print("收到：\(value)")
    })
    .disposed(by: disposeBag)

subject.onNext("Hello")
subject.onNext("RxSwift")
```

結果：
```
收到：Hello
收到：RxSwift
```

常見 Subject 類型

PublishSubject

只會收到訂閱之後發出的事件。
```
let subject = PublishSubject<String>()
```

適合：
* 按鈕事件
* 一次性通知
* 不需要保存目前狀態的事件

BehaviorSubject

會保存一個目前值，新訂閱者會立刻收到目前值。
```
let subject = BehaviorSubject(value: "初始值")
```
適合：
* 目前登入狀態
* 目前篩選條件
* 目前頁面資料

2. Relay 是什麼？

在 RxCocoa 裡常見的是：
```
PublishRelay
BehaviorRelay
```

Relay 和 Subject 很像，但有一個重要差別：

>Relay 不會發出 error，也不會 completed。

在 UI 狀態管理裡，Relay 通常更安全、也更常用。

例如：
```
let nameRelay = BehaviorRelay<String>(value: "")

nameRelay
    .subscribe(onNext: { name in
        print("目前名字：\(name)")
    })
    .disposed(by: disposeBag)

nameRelay.accept("David")
```
注意 Relay 是用：
```
.accept(...)
```
不是：
```
.onNext(...)
```

Subject / Relay 簡單比較

| 類型 | 是否有初始值 | 是否保存目前值 | 常見用途 |
| :--: | :--: | :--: | :--: 
| PublishSubject  | 否 | 否 | 一次性事件 |
| BehaviorSubject  | 是 | 是 | 狀態 |
| PublishRelay  | 否 | 否 | UI 事件 |
| BehaviorRelay  | 是 | 是 | UI 狀態 |

實務上你可以先記：
```
事件：PublishRelay
狀態：BehaviorRelay
```

### 實作
本日實作內容位於：**LoginViewController.swift**

#### 補充重點
combineLatest
```
Observable.combineLatest(a, b)
```
意思是：

>當 a 或 b 任一邊有新值時，就拿兩邊最新的值組合起來。

很適合表單驗證。

withLatestFrom
```
loginButton.rx.tap
    .withLatestFrom(formValid)
```
意思是：

>當按鈕被點擊時，取出 formValid 目前最新的值。

要記住這四個觀念：
```
PublishRelay：事件
BehaviorRelay：狀態
combineLatest：組合多個狀態
withLatestFrom：事件發生時取最新狀態
```

## Day 5：做一個小型搜尋功能，理解接近實務的寫法

要做一個很常見的功能：
* 輸入搜尋文字
* 等待使用者停止輸入
* 避免重複搜尋
* 模擬 API request
* 更新畫面

### 觀念
1. debounce
```
.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
```

意思是：

>使用者停止輸入 0.3 秒後，才繼續往下送出事件。

適合搜尋框，避免每打一個字就打 API。


2. distinctUntilChanged
```
.distinctUntilChanged()
```

意思是：

>如果新值和上一個值一樣，就不要重複送出。


3. flatMapLatest
```
.flatMapLatest { keyword in
    return search(keyword)
}
```
意思是：

>如果新的搜尋發生，就取消或忽略前一次尚未完成的結果，只保留最新那次。

搜尋功能非常適合用 flatMapLatest。

例如使用者輸入：
a → ap → app → apple

你通常只想要最後一次 apple 的搜尋結果。


### 實作
本日實作內容位於：**SearchViewController.swift**


五天後你應該具備的能力

完成這五天後，你應該可以做到：
```
看懂 Observable / subscribe / bind 的基本寫法
知道 DisposeBag 是做什麼的
能用 map / filter / compactMap 轉換資料流
能用 RxCocoa 綁定 Button、TextField、Label
知道 Subject / Relay 的差別
能用 combineLatest 做簡單表單驗證
能用 debounce / distinctUntilChanged / flatMapLatest 做搜尋功能
```

精簡版學習地圖

你可以把這五天濃縮成這樣記：

| 天數 | 主題 | 重點 |
| :--: | :--: | :--: |
| Day 1  | Observable / Subscribe | 理解事件流 |
| Day 2  | map / filter / compactMap | 轉換資料流 |
| Day 3  | RxCocoa + UIKit | 綁定 Button、TextField、Label |
| Day 4  | Relay + combineLatest | 處理 UI 狀態與表單驗證 |
| Day 5  | debounce + flatMapLatest | 做搜尋功能 |

最重要的是：
>RxSwift 不要用背的，要用「事件從哪裡來、經過哪些轉換、最後綁到哪裡」來理解。
