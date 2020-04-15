//
//  XSViewController.swift
//  XSBase
//
//  Created by LL on 2020/4/14.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
import RxSwift

open class XSViewController: UIViewController {

    //  MARK: - Properties
    
    open lazy var disposeBag = DisposeBag()
    
    /// 导航条
    open lazy var navBar: UINavigationBar = {
        view.insertSubview(customStatusBar, at: 0)
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: hStatusBar, width: view.bounds.width, height: 44))
        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        view.insertSubview(navBar, at: 1)
        
        navBar.items = [navItem]
        
        if let count = navigationController?.viewControllers.count,
            count > 1 {
            navItem.leftBarButtonItem = backItem
        }
        return navBar
    }()
    
    /// 自定义导航条目
    open lazy var navItem = UINavigationItem()
    
    /// 导航条背景颜色
    open var navBarBackgroundColor: UIColor = UIColor.white {
        didSet {
            customStatusBar.backgroundColor = navBarBackgroundColor
            navBar.setBackgroundImage(UIImage.create(color: navBarBackgroundColor), for: UIBarMetrics.default)
        }
    }
    
    /// 自定义状态栏
    private lazy var customStatusBar: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: hStatusBar))
        v.backgroundColor = UIColor.white
        return v
    }()
    
    /// 返回控件
    private lazy var backItem:UIBarButtonItem = {
        let btn = UIButton(title: backTitle, titleColor: .darkGray, font: UIFont.iconFont(ofSize: 18), target: self, action: #selector(goBack), type: .custom)
        return UIBarButtonItem(customView: btn)
    }()
    
    //  MARK: - LifeCycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
    }
    
    deinit {
        print("\(classForCoder) deinit")
    }
    
    open override var title: String? {
        didSet {
            navItem.title = title
        } 
    }
    
    //  MARK: - Monitor
    
    /// 返回上级控制器
    @objc open func goBack() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

}
