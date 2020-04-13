//
//  ViewController.swift
//  App
//
//  Created by LL on 2020/4/13.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
import AppBase
import SnapKit
 
class ViewController: UIViewController {
    
    lazy var btn = AppCountdownButton(title: "test", titleColor: .green, target: self, action: #selector(btnClick))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(200)
        }
        
    }
    
    @objc func btnClick() {
        btn.startCountdown()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @IBAction func cdbuttonClick(_ sender: AppCountdownButton) {
        sender.startCountdown()
    }
}

