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
}
