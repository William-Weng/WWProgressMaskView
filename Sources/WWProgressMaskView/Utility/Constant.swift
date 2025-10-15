//
//  ProgressMaskView.swift
//  WWProgressMaskView
//
//  Created by William.Weng on 2022/12/13.
//
/// [漸層圖片](https://webkul.github.io/coolhue/)

import UIKit

// MARK: - 常數
public extension WWProgressMaskView {
    
    typealias BasicAnimationInformation = (animation: CABasicAnimation, keyPath: TransitionAnimationKeyPath)   // Basic動畫資訊
    
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
    
    /// 畫線類型
    public enum DrawType {
        case accumulate                 // 累加型 (無動畫)
        case once(_ duration: CGFloat)  // 單次型 (有動畫)
    }
    
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum TransitionAnimationKeyPath: String {
        case strokeEnd = "strokeEnd"
        case position = "position"
        case rotation = "transform.rotation"
    }
}
