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
}

protocol SignUpViewModelOutput {
    var closeViewController: Observable<Void> { get }
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
    
    //-------------------------------------
    //MARK: - Output
    private var closeViewControllerProperty = Variable<Void>(())
    // VC側で購読しているOberverに「closeViewControllerPropertyのイベントを放出」
    var closeViewController: Observable<Void> {
        return closeViewControllerProperty.asObservable().skip(1)
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
        
        
    }
    
    
    
    
}
