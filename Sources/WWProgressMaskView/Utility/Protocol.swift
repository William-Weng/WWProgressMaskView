//
//  Protocol.swift
//  WWProgressMaskView
//
//  Created by William.Weng on 2024/11/15.
//

import UIKit

// MARK: - WWProgressMaskView.Delegate
extension WWProgressMaskView {
   
    public protocol Delegate: AnyObject {
        
        /// [進度條的移動角度](https://webkul.github.io/coolhue/)
        /// - Parameters:
        ///   - progressMaskView: WWProgressMaskView
        ///   - startAngle: CGFloat
        ///   - endAngle: CGFloat
        func progressMaskViewAngle(_ progressMaskView: WWProgressMaskView, from startAngle: CGFloat, to endAngle: CGFloat)
    }

}
