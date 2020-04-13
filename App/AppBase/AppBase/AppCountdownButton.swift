//
//  AppCountdownButton.swift
//  AppBase
//
//  Created by LL on 2020/4/13.
//  Copyright © 2020 hxxxs. All rights reserved.
//  倒计时按钮

import UIKit

open class AppCountdownButton: UIButton {

    var timer: Timer?
    open var countDownTimeInterval: Int = 60
    open var finshTitle: String = "重新获取"
    open var changeTitle: String = "s"
    
    deinit {
        print("\(classForCoder)" + " deinit")
    }
    
    open override func removeFromSuperview() {
        stopCountdown()
        super.removeFromSuperview()
    }
    
    // MARK: - Timer
    
    /// 倒计时
    @objc func countDown() {
        countDownTimeInterval -= 1
        if countDownTimeInterval == 0 {
            stopCountdown()
        } else {
            setTitle("\(countDownTimeInterval)" + changeTitle, for: .normal)
        }
    }
    
    /// 开始倒计时
    open func startCountdown(second: Int = 60) {
        timer?.invalidate()
        countDownTimeInterval = second
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        timer?.fire()
        isUserInteractionEnabled = false
    }
    
    /// 倒计时结束
    open func stopCountdown() {
        timer?.invalidate()
        timer = nil
        setTitle(finshTitle, for: .normal)
        isUserInteractionEnabled = true
    }
}
