//
//  XSTabbleViewController.swift
//  XSBase
//
//  Created by LL on 2020/4/15.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
import SnapKit

open class XSTabbleViewController: XSViewController {
    
    open lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        return tv
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }

}
