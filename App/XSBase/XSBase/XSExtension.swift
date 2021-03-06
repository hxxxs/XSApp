//
//  XSExtension.swift
//  XSBase
//
//  Created by LL on 2020/4/14.
//  Copyright © 2020 hxxxs. All rights reserved.
//

import UIKit

// MARK: - Foundation Extension

public extension Date {
    
    /// 自定义日期
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    /// - Returns: 日期
    init(year: Int, month: Int, day: Int = 1) {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        self.init(timeInterval: 0, since: Calendar(identifier: .gregorian).date(from: components)!)
    }
    
    /// 农历
    var lunar: [String: String] {
        let cal = Calendar(identifier: .chinese)
        let year = cal.component(.year, from: self)
        let month = cal.component(.month, from: self)
        let day = cal.component(.day, from: self)
  
        //  天干
        let heavenlyStemIndex = (year - 1) % HeavenlyStems.count
        let heavenlyStem = HeavenlyStems[heavenlyStemIndex]
        
        //  地支
        let earthlyBrancheIndex = (year - 1) % EarthlyBranches.count
        let earthlyBranche = EarthlyBranches[earthlyBrancheIndex]
        let yearString = "\(heavenlyStem)\(earthlyBranche)"
        
        //  生肖
        let zodiacIndex = (year - 1) % Zodiacs.count
        let zodiac = Zodiacs[zodiacIndex]
        
        //  月
        let monthIndex = (month - 1) % Months.count
        let monthString = Months[monthIndex]
        
        //  日
        let dayIndex = (day - 1) % Days.count
        let dayString = Days[dayIndex]
        
        return ["year": yearString,
                "zodiac": zodiac,
                "month": monthString,
                "day": dayString]
    }
    
    /// 前一个月
    var previousMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self)!
    }
    
    /// 下个月
    var nextMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        return Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self)!
    }
    
    /// 本月第一天
    var firstDayOfMonth: Date {
        let count = Calendar(identifier: .gregorian).component(.day, from: self)
        var dateComponents = DateComponents()
        dateComponents.day = -count + 1
        return Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self)!
    }
    
    /// 总天数
    var totaldaysInMonth: Int {
        return Calendar(identifier: .gregorian).range(of: .day, in: .month, for: self)!.count
    }
    
    /// 总周数
    var totalWeeksInMonth: Int {
        return Calendar(identifier: .gregorian).range(of: .weekOfMonth, in: .month, for: self)!.count
    }
    
    /// 天
    var day: Int {
        return Calendar(identifier: .gregorian).component(.day, from: self)
    }
    
    /// 月
    var month: Int {
        return Calendar(identifier: .gregorian).component(.month, from: self)
    }
    
    /// 年
    var year: Int {
        return Calendar(identifier: .gregorian).component(.year, from: self)
    }
}

public extension String {
    
    /// 时间戳转字符串
    ///
    /// - Parameters:
    ///   - dateFormat: 时间格式
    ///   - timeInterval: 时间戳（单位s）
    static func timestampConvertString(dateFormat: String = "yyyy-MM-dd HH:mm", timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateConvertString(dateFormat: dateFormat, date: date)
    }
    
    /// 日期转字符串
    ///
    /// - Parameters:
    ///   - dateFormat: 时间格式
    ///   - date: 日期
    static func dateConvertString(dateFormat: String = "yyyy-MM-dd HH:mm", date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.dateFormat = dateFormat
        return fmt.string(from: date)
    }
    
    /// 加密手机号
    var encryptionPhone: String {
        if !isPhoneNumber {
            debugPrint("无效的手机号")
            return self
        }
        
        let range = Range(NSRange(location: 3, length: 4), in: self)
        return replacingCharacters(in: range!, with: "****")
    }
    
    /// 金额格式化，千位符&保留2位小数
    var amountFormatter: String {
        
        guard let num = Float(self) else { return "" }
        
        let fmt = NumberFormatter()
        fmt.positiveFormat = "#,##0.00" //  #表示预设值，当数字没有此位时则舍去不补位，0表示位数，当数字没有此位时会以0去补位
        return fmt.string(from: num as NSNumber) ?? ""
    }
    
    //  MARK: - 沙盒路径
    
    /// 给当前文件追加文档路径
    var appendDocumentDir: String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        return dir!.appendingFormat("/%@", self)
    }
    
    /// 给当前文件追加缓存路径
    var appendCacheDir:String {
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        return dir!.appendingFormat("/%@", self)
    }
    
    /// 给当前文件追加临时路径
    var appendTempDir: String {
        return NSTemporaryDirectory().appending(self)
    }
    
    //  MARK: - 验证相关
    
    /// 纯中文
    var isChineseCharacters: Bool {
        let regex = "^[\\u4e00-\\u9fa5]+$";
        return vaildRegex(regex: regex)
    }
    
    /// 身份证号
    var isIdCardNumber: Bool {
        let regex = "^\\d{6}(18|19|20)?\\d{2}(0[1-9]|1[012])(0[1-9]|[12]\\d|3[01])\\d{3}(\\d|[xX])$"
        return vaildRegex(regex: regex)
    }
    
    /// 手机号
    var isPhoneNumber: Bool {
        let regex = "^1(3|4|5|6|7|8|9)\\d{9}$"
        return vaildRegex(regex: regex)
    }
    
    /// 正则校验
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    /// - Returns: 校验结果
    private func vaildRegex(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

public extension NSAttributedString {
    
    /// 使用图像和文本生成上下排列的属性文本
    ///
    /// - Parameters:
    ///   - img: 顶部图片
    ///   - title: 标题
    ///   - wh: 图片宽高，默认30
    ///   - fontSize: 标题大小，默认16号字
    ///   - color: 标题颜色，默认darkText
    ///   - space: 分隔距离，默认8
    convenience init(img: UIImage, title: String, wh: CGFloat = 30, fontSize: CGFloat = 16, color: UIColor = .darkText, space: CGFloat = 8) {
        
        // 图片属性文本
        let attachment = NSTextAttachment()
        attachment.image = img
        attachment.bounds = CGRect(x: 0, y: 0, width: wh, height: wh)
        let imgAttr = NSAttributedString(attachment: attachment)
        
        // 间距属性文本
        let spaceAttr = NSAttributedString(
            string: "\n\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: space)]
        )
        
        // 标题属性文本
        let titleAttr = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         .foregroundColor: color]
        )
        
        // 合并属性文本
        let attrM = NSMutableAttributedString(attributedString: imgAttr)
        attrM.append(spaceAttr)
        attrM.append(titleAttr)
        
        self.init(attributedString: attrM.copy() as! NSAttributedString)
    }
}

public extension Bundle {
    
    /// 命名空间
    var nameSpace: String {
        return infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
    
    /// 当前版本
    var currentVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

}

public extension Int {
    /// 以 iPhone 6 的屏幕为基准计算水平方向值
    var adaptWidth: CGFloat {
        return CGFloat(self).adaptWidth
    }
    
    /// 以 iPhone 6 的屏幕为基准计算垂直方向值
    var adaptHeight: CGFloat {
        return CGFloat(self).adaptHeight
    }
}

public extension Double {
    /// 以 iPhone 6 的屏幕为基准计算水平方向值
    var adaptWidth: CGFloat {
        return CGFloat(self).adaptWidth
    }
    
    /// 以 iPhone 6 的屏幕为基准计算垂直方向值
    var adaptHeight: CGFloat {
        return CGFloat(self).adaptHeight
    }
}

public extension Float {
    /// 以 iPhone 6 的屏幕为基准计算水平方向值
    var adaptWidth: CGFloat {
        return CGFloat(self).adaptWidth
    }
    
    /// 以 iPhone 6 的屏幕为基准计算垂直方向值
    var adaptHeight: CGFloat {
        return CGFloat(self).adaptHeight
    }
}

// MARK: - UIKit Extension

public extension UIFont {
    static func iconFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "iconFont", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

public extension CGFloat {
    
    /// 以 iPhone 6 的屏幕为基准计算水平方向值
    var adaptWidth: CGFloat {
        return self * wScreen / 375.0
    }
    
    /// 以 iPhone 6 的屏幕为基准计算垂直方向值
    var adaptHeight: CGFloat {
        return self * hScreen / 667.0
    }
}

public extension UITableViewCell {
    /// 注册并返回一个可重用单元格
    ///
    /// - Parameters:
    ///   - tableView: 注册单元格的tableview
    ///   - style: 单元格样式，默认样式default
    ///   - reuseIdentifier: 注册可重用单元格标识符
    static func cell(with tableView: UITableView,
                            style: UITableViewCell.CellStyle = .default,
                            reuseIdentifier: String? = nil) -> UITableViewCell {
        let identifier = reuseIdentifier ?? "\(classForCoder())Indentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
        }
        return cell!
    }
}

public extension UIViewController {
    
    /// alert
    /// - Parameters:
    ///   - message: 消息
    ///   - title: 标题
    ///   - cannelTitle: 取消按钮名称
    ///   - cannelHandler: 取消按钮回调
    ///   - confirmTitle: 确认按钮
    ///   - confirmHandler: 确认按钮回调
    ///   - completion: 完成回调
    func showAlertVC(message: String?,
                            title: String?,
                            cannelTitle: String?,
                            cannelHandler: ((UIAlertAction) -> Void)?,
                            confirmTitle: String?,
                            confirmHandler: ((UIAlertAction) -> Void)?,
                            completion: (() -> Void)?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cannelTitle != nil {
            vc.addAction(UIAlertAction(title: cannelTitle, style: .cancel, handler: cannelHandler))
        }
        if confirmTitle != nil {
            vc.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler))
        }
        present(vc, animated: true, completion: completion)
    }
    
    /// 通过storyboard初始化视图控制器
    static func vcFromStroyboard(name: String? = nil,
                                        identifier: String? = nil,
                                        bundle: Bundle? = nil) -> UIViewController {
        let sb = UIStoryboard(name: name ?? "\(classForCoder())", bundle: bundle)
        return sb.instantiateViewController(withIdentifier: identifier ?? "\(classForCoder())")
    }
}

public extension UIView {
    
    /// 通过xib初始化视图
    static func viewFromNib(nibName: String? = nil,
                                   bundle: Bundle? = nil) -> UIView {
        let nib = UINib(nibName: nibName ?? "\(classForCoder())", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).last as! UIView
    }
    
    // MARK: - Properties
    
    @IBInspectable var masksToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    var x : CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var y : CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var width : CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.width
        }
    }
    
    var height : CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.height
        }
    }
    
    var centerX : CGFloat {
        set {
            center.x = newValue
        }
        get {
            return center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            center.y = newValue
        }
        get {
            return center.y
        }
    }
    
    var size : CGSize {
        set {
            frame.size = newValue
        }
        get {
            return frame.size
        }
    }
    
    var origin : CGPoint {
        set {
            frame.origin = newValue
        }
        get {
            return frame.origin
        }
    }
    
    /// 视图快照
    var snapshotImage: UIImage {
        //  开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        //  绘制
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        //  获取结果
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        //  关闭绘图上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 隐藏红点
    func hiddenRedDot() {
        for v in subviews {
            if v.tag == 20180619 {
                v.removeFromSuperview()
            }
        }
    }
    
    /// 展示红点
    func showRedDot(wh: CGFloat = 8) {
        showRedDot(wh: wh, center: CGPoint(x: width, y: -wh / 2))
    }
    
    /// 展示红点
    func showRedDot(wh: CGFloat = 8, center: CGPoint) {
        hiddenRedDot()
        let redView = UIView(frame: CGRect(x: center.x, y: center.y, width: wh, height: wh))
        redView.backgroundColor = UIColor.red
        redView.cornerRadius = wh / 2
        redView.tag = 20180619
        addSubview(redView)
    }
    
    /// 抖动动画
    func animationShaker() {
        let kfanimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let cTx = transform.tx
        kfanimation.duration = 0.4
        kfanimation.values = [cTx, cTx+10, cTx-8, cTx+8, cTx-5, cTx+5, cTx]
        kfanimation.keyTimes = [(0), (0.225), (0.425), (0.525), (0.750), (0.875), (1)]
        kfanimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(kfanimation, forKey: "kShakerAnimationKey")
    }
    
    /// 弹跳动画
    func animationBeat() {
        transform = CGAffineTransform()
        UIView.animateKeyframes(withDuration: 0.3,
                                delay: 0,
                                options: UIView.KeyframeAnimationOptions(rawValue: 0),
                                animations:
            {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 3.0, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                UIView.addKeyframe(withRelativeStartTime: 1 / 3.0,
                                   relativeDuration: 1 / 3.0,
                                   animations: {
                                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                })
                UIView.addKeyframe(withRelativeStartTime: 2 / 3.0,
                                   relativeDuration: 1 / 3.0,
                                   animations: {
                                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
        }, completion: nil)
    }
}

public extension UILabel {
    
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 文字颜色
    ///   - textAlignment: 文字对齐方式
    ///   - numberOfLines: 行数
    convenience init(text: String? = nil, font: UIFont = .systemFont(ofSize: 16),
                            textColor: UIColor = .darkGray,
                            textAlignment: NSTextAlignment = .left,
                            numberOfLines: Int = 1) {
        self.init()
        
        configProperties(font: font,
                        textColor: textColor,
                        textAlignment: textAlignment,
                        numberOfLines: numberOfLines)
        
        self.text = text
        sizeToFit()
    }
    
    /// 配置属性
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 文字颜色
    ///   - textAlignment: 文字对齐方式
    ///   - numberOfLines: 行数
    func configProperties(font: UIFont = .systemFont(ofSize: 16),
                                textColor: UIColor = .darkGray,
                                textAlignment: NSTextAlignment = .left,
                                numberOfLines: Int = 1) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

public extension UIImage {
    
    /// 生成颜色图片
    /// - Parameter color: 图片颜色
    func createImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 裁剪成带圆弧的图片
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆弧半径
    ///   - imageSize: 图片大小，默认为当前图片大小
    ///   - lineWidth: 边框宽度，默认为0
    ///   - lineColor: 边框颜色，默认为白色
    ///   - backColor: 背景颜色，默认白色
    func ovalImage(cornerRadius: CGFloat, imageSize: CGSize? = nil, lineWidth: CGFloat = 0, lineColor: UIColor = .white, backColor: UIColor = .white) -> UIImage {
        //  定义绘制空间
        let rect: CGRect
        if imageSize != nil {
            rect = CGRect(x: 0, y: 0, width: imageSize!.width, height: imageSize!.width)
        } else {
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.width)
        }
        
        //  开启上下文绘制底层颜色
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        
        //  裁剪图片
        let patch = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        patch.addClip()
        draw(in: rect)
        
        //  边框
        let ovalPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        ovalPath.lineWidth = lineWidth
        lineColor.setStroke()
        ovalPath.stroke()
        
        //  获取结果关闭上下文
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 圆形裁剪
    var circular: UIImage {
    
        //  获取最短边长
        let shotest = min(size.width, size.height)

        //  设置绘图区间
        let rect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        
        //  开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        //  获取当前上下文
        let context = UIGraphicsGetCurrentContext()!
        
        //  设置裁剪区域
        context.addEllipse(in: rect)
        context.clip()
        
        //  绘制
        draw(in: rect)
        
        //  获取结果
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        //  关闭绘图上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 创建图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    static func create(color: UIColor,
                           size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        
        //  设置绘图区间
        let rect = CGRect(origin: .zero, size: size)
        //  开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        //  设置填充颜色
        color.setFill()
        //  填充区域
        UIRectFill(rect)
        //  获取结果
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        //  关闭绘图上下文
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIButton {
    
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - titleAttr: 标题属性文本
    ///   - image: 图片
    ///   - bgImage: 背景图片
    ///   - font: 字体
    ///   - textAlignment: 文字对齐方式
    ///   - numberOfLines: 行数
    ///   - target: 监听者对象
    ///   - action: 方法
    ///   - type: 按钮样式
    convenience init(title: String? = nil,
                            titleColor: UIColor = .darkGray,
                            titleAttr: NSAttributedString? = nil,
                            image: UIImage? = nil,
                            bgImage: UIImage? = nil,
                            font: UIFont = .systemFont(ofSize: 16),
                            textAlignment: NSTextAlignment = .left,
                            numberOfLines: Int = 1,
                            target: Any? = nil,
                            action: Selector? = nil,
                            type: UIButton.ButtonType = .system) {
        
        self.init(type: type)
        
        titleLabel?.configProperties(font: font,
                                    textAlignment: textAlignment,
                                    numberOfLines: numberOfLines)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setImage(image, for: .normal)
        setBackgroundImage(bgImage, for: .normal)
        setAttributedTitle(titleAttr, for: .normal)
        sizeToFit()
        
        guard action != nil else {
            return
        }
        addTarget(target, action: action!, for: .touchUpInside)
    }
    
    /// 创建顶部图片底部文字的按钮
    ///
    /// - Parameters:
    ///   - img: 图片
    ///   - title: 标题
    ///   - wh: 图片宽高，默认30
    ///   - fontSize: 标题文字大小，默认16
    ///   - color: 标题颜色，默认darkGray
    ///   - space: 图片和文字的间距大小，默认8
    ///   - type: 按钮样式，默认system
    convenience init(img: UIImage,
                            title: String,
                            wh: CGFloat = 30,
                            fontSize: CGFloat = 16,
                            color: UIColor = .darkGray,
                            space: CGFloat = 8,
                            type: UIButton.ButtonType = .system) {
        
        self.init(type: type)
        
        let attr = NSAttributedString(img: img,
                                      title: title,
                                      wh: wh,
                                      fontSize: fontSize,
                                      color: color, space: space)
        
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        
        setAttributedTitle(attr, for: .normal)
        sizeToFit()
    }
}

public extension UIColor {
    
    /// 随机色
    static var random: UIColor {
        
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    /// 使用 16 进制数字创建颜色
    ///
    /// - Parameter hex: 16 进制无符号32位整数
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        
        let r = CGFloat((hex & 0xff0000) >> 16)
        let g = CGFloat((hex & 0x00ff00) >> 8)
        let b = CGFloat(hex & 0x0000ff)
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
}

private var KEYPlACEHOLDERLABEL = "KEYPlACEHOLDERLABEL"

public extension UITextView {
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    /// 占位文本框
    var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &KEYPlACEHOLDERLABEL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholder), name: UITextView.textDidChangeNotification, object: self)
        }
        get {
            return objc_getAssociatedObject(self, &KEYPlACEHOLDERLABEL) as? UILabel
        }
    }
    
    var placeholder: String {
        set {
            placeholderLabel = UILabel(text: newValue, font: self.font ?? UIFont.systemFont(ofSize: 15), textColor: UIColor.lightGray, textAlignment: self.textAlignment, numberOfLines: 0)
            insertSubview(placeholderLabel!, at: 0)
            
            let x = textContainerInset.left + textContainer.lineFragmentPadding + layer.borderWidth;
            let y = textContainerInset.top + layer.borderWidth
            let w = width - x - textContainerInset.right - 2 * layer.borderWidth
            let h = placeholderLabel!.sizeThatFits(CGSize(width: w, height: 0)).height
            placeholderLabel!.frame = CGRect(x: x, y: y, width: w, height: h)
            
            updatePlaceholder()
        }
        get {
            return placeholderLabel?.text ?? ""
        }
    }
    
    @objc func updatePlaceholder() {
        placeholderLabel!.isHidden = text.count > 0
    }
}

//  MARK: - QuartzCore

public extension CALayer {
    @IBInspectable var borderColorFromUIColor: UIColor {
        set {
            borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: borderColor!)
        }
    }
}
