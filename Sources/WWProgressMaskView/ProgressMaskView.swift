//
//  ProgressMaskView.swift
//  WWProgressMaskView
//
//  Created by William.Weng on 2022/12/13.
//
/// [漸層圖片](https://webkul.github.io/coolhue/)

import UIKit

/// 進度單位 => 1% / 1‰ / 1‱ (整數比較不會有誤差值)
public enum ProgressUnit {
    
    case percent(_ number: Int)     // 百分之一 (1 / 100 -> 1%)
    case permil(_ number: Int)      // 千分之一 (1 / 1000 -> 1‰)
    case basisPoint(_ number: Int)  // 萬分之一 (1 / 10000 -> 1‱)
    
    /// 換算數值成小數 => 0% ~ 100%
    /// - Returns: CGFloat
    func decimal() -> CGFloat {
        switch self {
        case .percent(let number): return number._CGFloat() * 0.01
        case .permil(let number): return number._CGFloat() * 0.001
        case .basisPoint(let number): return number._CGFloat() * 0.0001
        }
    }
}

// MARK: - 動態的進度條
@IBDesignable
open class WWProgressMaskView: UIView {
    
    @IBInspectable var clockwise: Bool = false
    @IBInspectable var lineWidth: Int = 10
    @IBInspectable var originalAngle: Int = 0
    @IBInspectable var innerImage: UIImage = UIImage()
    @IBInspectable var outerImage: UIImage = UIImage()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var innerImageView: UIImageView!
    @IBOutlet weak var outerImageView: UIImageView!
    
    private let returnZeroAngle: CGFloat = -90
    private let innerStartAngle: CGFloat = 0
    private let innerEndAngle: CGFloat = 360
    
    private var lineCap: CAShapeLayerLineCap = .butt
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
        initDefaultImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
        initDefaultImage()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        initSetting(lineWidth: lineWidth, clockwise: clockwise, lineCap: lineCap)
    }
    
    /// [IB Designables: Failed to render and update auto layout status](https://stackoverflow.com/questions/46723683/ib-designables-failed-to-render-and-update-auto-layout-status)
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentView.prepareForInterfaceBuilder()
    }
}

// MARK: - 開放用功能
public extension WWProgressMaskView {
    
    /// 設定一些初始值 => 會重畫
    /// - Parameters:
    ///   - originalAngle: 初始角度
    ///   - lineWidth: 線寬
    ///   - clockwise: 順時針 / 逆時針
    ///   - innerImage: 內圈軌道的背景圖 (有預設圖片)
    ///   - outerImage: 外圈進度的背景圖 (有預設圖片)
    ///   - lineCap: [線條頭尾的長相](https://developer.apple.com/documentation/quartzcore/cashapelayerlinecap)
    func setting(originalAngle: Int = 0, lineWidth: Int = 10, clockwise: Bool = false, lineCap: CAShapeLayerLineCap = .butt, innerImage: UIImage? = nil, outerImage: UIImage? = nil) {
        
        self.lineWidth = lineWidth
        self.clockwise = clockwise
        self.innerImage = innerImage ?? self.innerImage
        self.outerImage = outerImage ?? self.outerImage
        self.lineCap = lineCap
        self.originalAngle = originalAngle
        
        self.setNeedsDisplay()
    }
    
    /// 畫進度條 (以角度為準)
    /// - Parameters:
    ///   - startAngle: 啟始角度 (-180 ~ 180)
    ///   - endAngle: 結束角度 (180 ~ -180)
    func progressCircle(from startAngle: Int, to endAngle: Int) {
        
        let _startAngle = fixAngle(angle: startAngle)
        let _endAngle = fixAngle(angle: endAngle)
        
        outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle._CGFloat(), to: _endAngle._CGFloat(), clockwise: clockwise, lineCap: lineCap)
    }
    
    /// 畫進度條
    /// - Parameter progressUnit: 百分之一 / 千分之一 / 萬分之一
    func progressCircle(progressUnit: ProgressUnit) {
        
        let percentValueAngle = progressUnit.decimal()._percentValue(from: innerStartAngle, to: innerEndAngle)
        let endAngle = (!clockwise) ? percentValueAngle : -(percentValueAngle + 360)
        let _startAngle = fixAngle(angle: 0)
        
        var _endAngle = endAngle + originalAngle._CGFloat() + returnZeroAngle
        if (!clockwise && (_endAngle >= returnZeroAngle)) { _endAngle += 360 }
        
        outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle._CGFloat(), to: _endAngle, clockwise: clockwise, lineCap: lineCap)
    }
}

// MARK: - 小工具
private extension WWProgressMaskView {
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: Self.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds

        addSubview(contentView)
    }
    
    /// 設定預設圖片
    func initDefaultImage() {
        
        guard let bundle = Optional.some(Bundle.module),
              let defaultInnerImage = UIImage(named: "inner", in: bundle, with: nil),
              let defaultOuterImage = UIImage(named: "outer", in: bundle, with: nil)
        else {
            return
        }

        innerImage = defaultInnerImage
        outerImage = defaultOuterImage
    }
    
    /// 初始化設定
    /// - Parameters:
    ///   - lineWidth: 線寬
    ///   - clockwise: 順時針 / 逆時針
    ///   - lineCap: 線條頭尾的長相
    func initSetting(lineWidth: Int, clockwise: Bool, lineCap: CAShapeLayerLineCap = .butt) {
        
        innerImageView.image = innerImage
        outerImageView.image = outerImage
        
        innerCircleSetting(lineWidth: lineWidth._CGFloat(), from: innerStartAngle, to: innerEndAngle, clockwise: clockwise, lineCap: lineCap)
        outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: 0, to: 0, clockwise: clockwise, lineCap: lineCap)
    }
    
    /// [設定內圈軌道的Layer層](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-uiview-的-mask-設計特別形狀的圖片-4e22cd7c3fbe)
    /// - Parameters:
    ///   - lineWidth: 線寬
    ///   - startAngle: 啟始角度 (-180 ~ 180)
    ///   - endAngle: 結束角度 (-180 ~ 180)
    ///   - clockwise: 順時針 / 逆時針
    ///   - lineCap: 線條頭尾的長相
    func innerCircleSetting(lineWidth: CGFloat, from startAngle: CGFloat, to endAngle: CGFloat, clockwise: Bool, lineCap: CAShapeLayerLineCap = .butt) {
        
        let path = innerImageView._circlePath(from: startAngle._radian(), to: endAngle._radian(), lineWidth: lineWidth, clockwise: clockwise)
        let layer = CAShapeLayer()._path(path)._lineWidth(lineWidth)._fillColor(nil)._strokeColor(.gray)._lineCap(lineCap)
        innerImageView.layer.mask = layer
    }
    
    /// [設定外圈進度的Layer層](https://medium.com/彼得潘的-swift-ios-app-開發教室/作業4-利用-uibezierpath-實現圓環進度條-甜甜圈圖表-圓餅圖-5de1cd6da16d)
    /// - Parameters:
    ///   - lineWidth: 線寬
    ///   - startAngle: 啟始角度 (-180 ~ 180)
    ///   - endAngle: 結束角度 (-180 ~ 180)
    ///   - clockwise: 順時針 / 逆時針
    ///   - lineCap: 線條頭尾的長相
    func outerCircleSetting(lineWidth: CGFloat, from startAngle: CGFloat, to endAngle: CGFloat, clockwise: Bool, lineCap: CAShapeLayerLineCap = .butt) {
        
        let path = outerImageView._circlePath(from: startAngle._radian(), to: endAngle._radian(), lineWidth: lineWidth, clockwise: clockwise)
        let layer = CAShapeLayer()._path(path)._lineWidth(lineWidth)._fillColor(nil)._strokeColor(.gray)._lineCap(lineCap)
        outerImageView.layer.mask = layer
    }
    
    /// 角度修正 / 歸零
    /// - Parameter angle: Int
    func fixAngle(angle: Int) -> Int { return angle + originalAngle + returnZeroAngle._int() }
}
