//
//  SignUpViewModel.swift
//  RxSwiftInputOutputProtocol
//
//  Created by park kyung suk on 2017/11/19.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import RxSwift

protocol SignUpViewModelInput {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func closeButtonTapped()
    func inputEmail(with text: String)
    func inputPassword(with text: String)
    func signUpButtonTapped()
}

protocol SignUpViewModelOutput {
    var closeViewController: Observable<Void> { get }
    var enableSignUpButton: Observable<Bool> { get }
    var showSignUpCompletedView: Observable<Void> { get }
}

protocol SignUpViewModelType {
    var input: SignUpViewModelInput { get }
    var output: SignUpViewModelOutput { get }
}

class SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput, SignUpViewModelType {
    
    let bag = DisposeBag()
    
    //-------------------------------------
    //MARK: - Input
    func viewDidLoad() {
    }
    
    func viewWillAppear(_ animated: Bool) {
    }

    private var closeButtonTappedProperty = Variable<Void>(())
    func closeButtonTapped() {
        closeButtonTappedProperty.value = ()
    }
    
    private var inputEmailProperty = Variable<String>("")
    func inputEmail(with text: String) {
        inputEmailProperty.value = text
    }
    
    private var inputPasswordProperty = Variable<String>("")
    func inputPassword(with text: String) {
        inputPasswordProperty.value = text
    }
    
    private var signUpButtonTappedProperty = Variable<Void>(())
    func signUpButtonTapped() {
        signUpButtonTappedProperty.value = ()
    }
    
    
    //-------------------------------------
    //MARK: - Output
    private var closeViewControllerProperty = Variable<Void>(())
    // VC側で購読しているOberverに「closeViewControllerPropertyのイベントを放出」
    var closeViewController: Observable<Void> {
        return closeViewControllerProperty.asObservable().skip(1)
    }
    
    private var enableSignUpButtonProperty = Variable<Bool>(false)
    var enableSignUpButton: Observable<Bool> {
        return enableSignUpButtonProperty.asObservable()
    }
    
    private var showSignUpCompletedViewProperty = Variable<Void>(())
    var showSignUpCompletedView: Observable<Void> {
        return showSignUpCompletedViewProperty.asObservable().skip(1)
    }
    
    //-------------------------------------
    //MARK: - Type
    var input: SignUpViewModelInput { return self }
    var output: SignUpViewModelOutput { return self }
    
    
    //-------------------------------------
    //MARK: init
    init() {
        
        closeButtonTappedProperty.asObservable()
            .subscribe(onNext: { [unowned self] in
                print("Emitted closeButtonTappedProperty ")
                //なんらかの処理やバリデーションチェックがあればする
                //最後にOutにイベントを送信
                self.closeViewControllerProperty.value = ()
            })
            .disposed(by: bag)
        
        
        inputEmailProperty.asObservable()
            .subscribe(onNext: { email in
                print("emitted inputEmailProperty : \(email)")
                //なんらかのバリデーションをする
            })
            .disposed(by: bag)
        
        inputPasswordProperty.asObservable()
            .subscribe(onNext: { [unowned self] password in
                print("emitted inputPasswordProperty : \(password)")
                
                self.enableSignUpButtonProperty.value = password.count > 7 ? true : false
            })
            .disposed(by: bag)
        
        
        // signUpボタンがタップのinputがあった場合にはOutのshowCompletedにイベントを放出する
        signUpButtonTappedProperty.asObservable()
            .subscribe(onNext: { _ in
                print("emitted signUpButtonTappedProperty")
                //なんらかのバリデーションがあればする
                
                self.showSignUpCompletedViewProperty.value = ()
            })
            .disposed(by: bag)
    }
    
    
    
    
}
