//
//  TestViewController.swift
//  App
//
//  Created by LL on 2020/4/14.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
import XSBase
import SnapKit

class TestViewController: XSViewController {
    lazy var contentView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
