//
//  Extension.swift
//  WWProgressMaskView
//
//  Created by William.Weng on 2022/12/13.
//

import UIKit

// MARK: - Int (class function)
extension Int {
    
    /// 轉成CGFloat
    /// - Returns: CGFloat
    func _CGFloat() -> CGFloat { return CGFloat(self) }
    
    /// 180° => π
    func _radian() -> CGFloat { return self._CGFloat()._radian() }
    
    /// π => 180°
    func _angle() -> CGFloat { return self._CGFloat()._angle() }
}

// MARK: - CGFloat (class function)
extension CGFloat {
    
    /// 5.3 => 5
    func _int() -> Int { return Int(self) }
    
    /// 180° => π
    func _radian() -> CGFloat { return (self / 180.0) * .pi }
    
    /// π => 180°
    func _angle() -> CGFloat { return self * (180.0 / .pi) }
    
    /// 將百分比 => 區間的數字
    /// - Parameters:
    ///   - startValue: 開始範圍的數值
    ///   - endValue: 結束範圍的數值
    /// - Returns: CGFloat
    func _percentValue(from startValue: CGFloat, to endValue: CGFloat) -> CGFloat {
        
        let angleScope = abs(endValue - startValue)
        
        if endValue > startValue { return self * angleScope - endValue }
        return self * angleScope - startValue
    }
}

// MARK: - UIView (function)
extension UIView {
    
    /// 圓形(弧)路徑
    /// - View的半徑
    /// - Parameters:
    ///   - startAngle: 開始的角度
    ///   - endAngle: 結束的角度
    ///   - clockwise: 順時針 / 逆時針
    ///   - lineWidth: 線寬
    /// - Returns: CGMutablePath
    func _circlePath(from startAngle: CGFloat = .zero, to endAngle: CGFloat = .pi, lineWidth: CGFloat = 0.0, clockwise: Bool = false) -> CGMutablePath {
        let path = CGPath._buildCirclePath(center: center, radius: _fitRadius(lineWidth: lineWidth), from: startAngle, to: endAngle, clockwise: clockwise)
        return path
    }
    
    /// 找出適合的半徑 (寬或高的一半)
    /// - Returns: CGFloat
    /// - Parameters:
    ///   - lineWidth: 線寬
    func _fitRadius(lineWidth: CGFloat = 0.0) -> CGFloat {
        let fitDiameter = (frame.height > frame.width) ? frame.width : frame.height
        return (fitDiameter - lineWidth) * 0.5
    }
    
    /// 取得View的旋轉角度 (徑度)
    /// - Returns: CGFloat
    func _rotationRadian() -> CGFloat {
        let transform = self.transform
        return atan2(transform.b, transform.a)
    }
}

// MARK: - CAShapeLayer (class function)
extension CAShapeLayer {
    
    /// 設定路徑
    /// - Parameter path: CGPath
    /// - Returns: Self
    func _path(_ path: CGPath) -> Self { self.path = path; return self }
    
    /// 設定填滿的顏色
    /// - Parameter color: UIColor
    /// - Returns: Self
    func _fillColor(_ color: UIColor?) -> Self { self.fillColor = color?.cgColor; return self }

    /// 設定框線的顏色
    /// - Parameter color: UIColor
    /// - Returns: Self
    func _strokeColor(_ color: UIColor?) -> Self { self.strokeColor = color?.cgColor; return self }
    
    /// 設定框線寬度
    /// - Parameter width: 框線寬度
    /// - Returns: Self
    func _lineWidth(_ width: CGFloat) -> Self { self.lineWidth = width; return self }
    
    /// 設定兩邊端點的樣子
    /// - Parameter round: CAShapeLayerLineCap
    /// - Returns: Self
    func _lineCap(_ round: CAShapeLayerLineCap = .butt) -> Self { self.lineCap = round; return self }
}

// MARK: - CGPath (class function)
extension CGPath {
    
    /// 建立圓形(弧)路徑
    /// - View的半徑
    /// - Parameters:
    ///   - center: 中點
    ///   - radius: 半徑
    ///   - startAngle: 開始的角度
    ///   - endAngle: 結束的角度
    ///   - clockwise: 順時針 / 逆時針
    /// - Returns: CGMutablePath
    static func _buildCirclePath(center: CGPoint, radius: CGFloat, from startAngle: CGFloat = .zero, to endAngle: CGFloat = .pi, clockwise: Bool = false) -> CGMutablePath {

        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        return path
    }
}

// MARK: - CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - delegate: [CAAnimationDelegate?](https://juejin.cn/post/6936070813648945165)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    ///   - repeatCount: 播放次數
    ///   - fillMode: [CAMediaTimingFillMode](https://juejin.cn/post/6991371790245183496)
    ///   - timingFunction: CAMediaTimingFunction?
    ///   - isRemovedOnCompletion: Bool
    /// - Returns: WWProgressMaskView.CAAnimationInformation
    static func _basicAnimation(keyPath: WWProgressMaskView.TransitionAnimationKeyPath, delegate: CAAnimationDelegate?, fromValue: Any?, toValue: Any?, duration: CFTimeInterval, repeatCount: Float = 1.0, fillMode: CAMediaTimingFillMode = .forwards, timingFunction: CAMediaTimingFunction?, isRemovedOnCompletion: Bool = false) -> WWProgressMaskView.BasicAnimationInformation {
        
        let animation = CABasicAnimation(keyPath: keyPath.rawValue)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fillMode = fillMode
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.delegate = delegate
        animation.timingFunction = timingFunction
        
        return (animation, keyPath)
    }
}
