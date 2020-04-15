//
//  XSWebViewController.swift
//  XSBase
//
//  Created by LL on 2020/4/15.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit
import WebKit

open class XSWebViewController: XSViewController, WKNavigationDelegate, WKUIDelegate {
    
    //  MARK: - Properties
    
    open var url: String = "" {
        didSet {
            url = url.replacingOccurrences(of: " ", with: "")
        }
    }
    
    open lazy var webView: WKWebView = {
        let wv = WKWebView(frame: CGRect.zero, configuration: self.configuration)
        wv.navigationDelegate = self
        wv.uiDelegate = self
        return wv
    }()
    
    open lazy var configuration = WKWebViewConfiguration()
    
    open lazy var progress: UIProgressView = {
        let v = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.width, height: 1))
        v.progressTintColor = UIColor.blue
        return v
    }()
    
    private var observation: NSKeyValueObservation?
    
    //  MARK: - LifeCycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        
        webView.addSubview(progress)
        
        observation = webView.observe(\.estimatedProgress, options: [.new], changeHandler: {[weak self] (_, change) in
            if let progress = change.newValue {
                self?.progress.progress = Float(progress)
                self?.progress.isHidden = progress >= 1
            }
        })
        
        loadRequest()
    }
    
    //  MARK: - Public Func
    
    open override func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.goBack()
        }
    }
    
    open func loadRequest() {
        if url.count > 0,
            let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    //  MARK: - UINavigationDelegate
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.mainDocumentURL?.absoluteString ?? ""
        debugPrint("webview load request url ==> \(url)")
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
}
