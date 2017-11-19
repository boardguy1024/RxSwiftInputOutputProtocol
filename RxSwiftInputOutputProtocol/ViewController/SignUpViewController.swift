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
        
        // input bind
        closeButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                //closeボタンがタップされたことをViewModelに通知する
                self.viewModel.input.closeButtonTapped()
            })
            .disposed(by: bag)
        
        
        // output bind
        
        //ViewModelはVCにVCを閉じるよう通知する。
        viewModel.output.closeViewController
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

}
