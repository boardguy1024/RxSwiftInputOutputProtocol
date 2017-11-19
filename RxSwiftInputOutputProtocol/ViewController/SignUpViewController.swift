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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1) { [unowned self] in
            self.blurEffectView.alpha = 1
        }
    }

}
