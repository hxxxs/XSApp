//
//  ViewController.swift
//  App
//
//  Created by LL on 2020/4/13.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
}

