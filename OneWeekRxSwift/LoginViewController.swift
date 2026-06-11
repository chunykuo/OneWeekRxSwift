//
//  LoginViewController.swift
//  OneWeekRxSwift
//
//  Created by David Kuo on 2026/6/11.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    private func bindUI() {
        let emailValid = emailTextField.rx.text
            .orEmpty
            .map { !$0.isEmpty }
        
        let passwordValid = passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 6 }
        
        // 登入(按鈕)條件：兩者都符合時，loginButton 才可以點
        let formValid = Observable
            .combineLatest(emailValid, passwordValid) { emailValid, passwordValid in
                return emailValid && passwordValid
            }
        
        formValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .withLatestFrom(formValid)
            .filter { $0 }
            .map { _ in "可以登入" }
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
