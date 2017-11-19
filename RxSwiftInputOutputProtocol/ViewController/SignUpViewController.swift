//
//  SignUpViewController.swift
//  RxSwiftInputOutputProtocol
//
//  Created by park kyung suk on 2017/11/19.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let bag = DisposeBag()
    let viewModel: SignUpViewModelType = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1) { [unowned self] in
            self.blurEffectView.alpha = 1
        }
    }
    
    private func commonInit() {
        blurEffectView.alpha = 0
    }
    
    func bindViewModel() {
        
        //------------------------------------------------
        // input bind
        closeButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                //closeボタンがタップされたことをViewModelに通知する
                self.viewModel.input.closeButtonTapped()
            })
            .disposed(by: bag)
        
        //email textField
        emailTextField.rx.text.asObservable()
            .subscribe(onNext: { [unowned self] email in
                self.viewModel.input.inputEmail(with: email!)
            })
            .disposed(by: bag)
        
        passwordTextField.rx.text.asObservable()
            .subscribe(onNext: { [unowned self] password in
                self.viewModel.input.inputPassword(with: password!)
            })
            .disposed(by: bag)
        
        signUpButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in
                //ボタンがタップされたとinputを通してViewModelに通知
                self.viewModel.input.signUpButtonTapped()
            })
            .disposed(by: bag)
        
        
        //------------------------------------------------
        // output bind
        
        //ViewModelはVCにVCを閉じるよう通知する。
        viewModel.output.closeViewController
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        //最初には登録ボタンを無効とする。
        //passwordのバリデーションがOKとなれば有効にする
        viewModel.output.enableSignUpButton
            .bind(to: self.signUpButton.rx.isEnabled)
            .disposed(by: bag)
        
        
        viewModel.output.enableSignUpButton
            .subscribe(onNext: { [unowned self] isEnabled in
                self.signUpButton.setTitleColor(isEnabled ? UIColor.white : UIColor.red, for: .normal)
            })
            .disposed(by: bag)
        
        viewModel.output.showSignUpCompletedView
            .subscribe(onNext: { _ in
                //alertViewを表示
                let alertConroller = UIAlertController(title: "SignUp", message: "登録が成功しました！", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    //直接 self.dimissではなく必ずinputを通してViewModelに通知すること
                    self.viewModel.input.closeButtonTapped()
                })
                
                alertConroller.addAction(ok)
                self.present(alertConroller, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}













