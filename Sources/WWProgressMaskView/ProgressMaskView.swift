//
//  ProgressMaskView.swift
//  WWProgressMaskView
//
//  Created by William.Weng on 2022/12/13.
//
/// [漸層圖片](https://webkul.github.io/coolhue/)

import UIKit

// MARK: - 動態的進度條
@IBDesignable
open class WWProgressMaskView: UIView {
    
    @IBInspectable var clockwise: Bool = false
    @IBInspectable var hiddenMarkerView: Bool = true
    @IBInspectable var lineWidth: Int = 10
    @IBInspectable var lineGap: CGFloat = 0.0
    @IBInspectable var originalAngle: Int = 0
    @IBInspectable var innerImage: UIImage = UIImage()
    @IBInspectable var outerImage: UIImage = UIImage()
    @IBInspectable var markerImage: UIImage = UIImage()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var innerImageView: UIImageView!
    @IBOutlet weak var outerImageView: UIImageView!
    @IBOutlet weak var markerImageView: UIImageView!
    
    private let returnZeroAngle: Int = -90
    
    private var innerStartAngle: Int = 0
    private var innerEndAngle: Int = 360
    
    private var lineCap: CAShapeLayerLineCap = .butt
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        initSetting(lineWidth: lineWidth, clockwise: clockwise, lineCap: lineCap)
    }
    
    /// [IB Designables: Failed to render and update auto layout status](https://stackoverflow.com/questions/46723683/ib-designables-failed-to-render-and-update-auto-layout-status)
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initSetting(lineWidth: lineWidth, clockwise: clockwise, lineCap: lineCap)
        initMarkerImageView()
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
    ///   - hiddenMarkerView: 不顯示MarkerView (進度條的指標)
    ///   - innerImage: 內圈軌道的背景圖 (有預設圖片)
    ///   - outerImage: 外圈進度的背景圖 (有預設圖片)
    ///   - outerImage: 進度條的指標圖 (有預設圖片)
    ///   - lineCap: [線條頭尾的長相](https://developer.apple.com/documentation/quartzcore/cashapelayerlinecap)
    ///   - lineGap: 內環與外環的距離
    ///   - innerStartAngle: 開始的角度
    ///   - innerEndAngle: 結束的角度
    func setting(originalAngle: Int = 0, lineWidth: Int = 10, clockwise: Bool = false, hiddenMarkerView: Bool = true, lineCap: CAShapeLayerLineCap = .butt, lineGap: CGFloat, innerImage: UIImage? = nil, outerImage: UIImage? = nil, markerImage: UIImage? = nil, innerStartAngle: Int = 0, innerEndAngle: Int = 360) {
        
        if (lineGap < 0) { progressView.bringSubviewToFront(innerImageView) }
        
        let newInnerImage = (lineGap < 0) ? (outerImage ?? self.outerImage) : (innerImage ?? self.innerImage)
        let newOuterImage = (lineGap < 0) ? (innerImage ?? self.innerImage) : (outerImage ?? self.outerImage)
        let newMarkerImage = markerImage ?? self.markerImage
        
        self.lineWidth = lineWidth
        self.clockwise = clockwise
        self.innerImage = newInnerImage
        self.outerImage = newOuterImage
        self.markerImage = newMarkerImage
        self.lineCap = lineCap
        self.lineGap = lineGap
        self.innerStartAngle = innerStartAngle + returnZeroAngle
        self.innerEndAngle = innerEndAngle + returnZeroAngle
        self.hiddenMarkerView = hiddenMarkerView
        
        self.originalAngle = (originalAngle < 0) ? (originalAngle % 360) + innerEndAngle : originalAngle % 360
        self.rotationMarkerView(anele: fixAngle(angle: 0))
        self.setNeedsDisplay()
    }
    
    /// 畫進度條 (以角度為準)
    /// - Parameters:
    ///   - startAngle: 啟始角度 (-180 ~ 180)
    ///   - endAngle: 結束角度 (180 ~ -180)
    func progressCircle(from startAngle: CGFloat, to endAngle: CGFloat) {
        
        let _startAngle = fixAngle(angle: startAngle)
        let _endAngle = fixAngle(angle: endAngle)
        
        if (lineGap < 0) {
            innerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle, to: _endAngle, clockwise: clockwise, lineCap: lineCap)
        } else {
            outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle, to: _endAngle, clockwise: clockwise, lineCap: lineCap)
        }
    }
    
    /// 畫進度條
    /// - Parameter progressUnit: 百分之一 / 千分之一 / 萬分之一
    func progressCircle(progressUnit: ProgressUnit) {
        
        let percentValueAngle = parsePercentValueAngle(progressUnit: progressUnit)
        let endAngle = (!clockwise) ? percentValueAngle : -(percentValueAngle + 360)

        let _startAngle = fixAngle(angle: 0)
        var _endAngle = fixAngle(angle: endAngle)
        
        if (!clockwise && (_endAngle >= returnZeroAngle._CGFloat())) { _endAngle += 360 }
        let fixCircularSectorAngle = circularSectorAngle()
        let _fixEndAngle = _endAngle - fixCircularSectorAngle._CGFloat()
        
        if (lineGap < 0) {
            innerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle, to: _fixEndAngle, clockwise: clockwise, lineCap: lineCap)
        } else {
            outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: _startAngle, to: _fixEndAngle, clockwise: clockwise, lineCap: lineCap)
        }
        
        rotationMarkerView(anele: _fixEndAngle)
    }
}

// MARK: - 小工具
private extension WWProgressMaskView {
    
    /// 初始化設定
    func initSetting() {
        initViewFromXib()
        initDefaultImage()
        initMarkerImageView()
    }
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: WWProgressMaskView.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// 設定預設圖片
    func initDefaultImage() {
        
        guard let bundle = Optional.some(Bundle.module),
              let defaultInnerImage = UIImage(named: "inner", in: bundle, with: nil),
              let defaultOuterImage = UIImage(named: "outer", in: bundle, with: nil),
              let defaultMarkerImage = UIImage(named: "marker", in: bundle, with: nil)
        else {
            return
        }
        
        innerImage = defaultInnerImage
        outerImage = defaultOuterImage
        markerImage = defaultMarkerImage
    }
    
    /// 設定markerImageView的中央基準點 (錨點)
    func initMarkerImageView() {
        markerImageView.layer.anchorPoint = .init(x: 0.25, y: 0.5)
    }
    
    /// 初始化設定
    /// - Parameters:
    ///   - lineWidth: 線寬
    ///   - clockwise: 順時針 / 逆時針
    ///   - lineCap: 線條頭尾的長相
    func initSetting(lineWidth: Int, clockwise: Bool, lineCap: CAShapeLayerLineCap = .butt) {
        
        innerImageView.image = innerImage
        outerImageView.image = outerImage
        markerImageView.image = markerImage
        
        if (lineGap < 0) {
            outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: innerStartAngle._CGFloat(), to: innerEndAngle._CGFloat(), clockwise: clockwise, lineCap: lineCap)
            innerCircleSetting(lineWidth: lineWidth._CGFloat(), from: innerStartAngle._CGFloat(), to: innerStartAngle._CGFloat(), clockwise: clockwise, lineCap: lineCap)
        } else {
            innerCircleSetting(lineWidth: lineWidth._CGFloat(), from: innerStartAngle._CGFloat(), to: innerEndAngle._CGFloat(), clockwise: clockwise, lineCap: lineCap)
            outerCircleSetting(lineWidth: lineWidth._CGFloat(), from: innerStartAngle._CGFloat(), to: innerStartAngle._CGFloat(), clockwise: clockwise, lineCap: lineCap)
        }
        
        rotationMarkerView(anele: fixAngle(angle: 0))
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
        let layer = CAShapeLayer()._path(path)._lineWidth(lineWidth - abs(lineGap))._fillColor(nil)._strokeColor(.gray)._lineCap(lineCap)
        
        outerImageView.layer.mask = layer
    }
    
    /// 角度修正 / 歸零
    /// - Parameter angle: CGFloat
    func fixAngle(angle: CGFloat) -> CGFloat { return angle + originalAngle._CGFloat() + returnZeroAngle._CGFloat() }
    
    /// 百分比 (0% ~ 100%) => 角度
    /// - Parameter progressUnit: 百分之一 / 千分之一 / 萬分之一
    /// - Returns: CGFloat
    func parsePercentValueAngle(progressUnit: ProgressUnit) -> CGFloat {
        
        var percent = progressUnit.decimal()
        
        if (percent < 0.0) { percent = 0.0 }
        if (percent > 1.0) { percent = 1.0 }
        
        return percent._percentValue(from: innerStartAngle._CGFloat(), to: innerEndAngle._CGFloat())
    }
    
    ///  計算扇形的角度要做的修正，因為未滿360度
    /// - Returns: Int
    func circularSectorAngle() -> Int {

        var differentAngle = (innerEndAngle - innerStartAngle - 360) % 360 / 2
        if (differentAngle != 0 && clockwise) { differentAngle -= 180 }
        
        return differentAngle
    }
    
    /// 旋轉進度條的指標
    /// - Parameter anele: CGFloat
    func rotationMarkerView(anele: CGFloat) {
        
        let currentRotationRadian = markerView._rotationRadian()
                
        markerView.transform = markerView.transform.rotated(by: anele._radian() - currentRotationRadian)
        markerView.isHidden = hiddenMarkerView
    }
}
