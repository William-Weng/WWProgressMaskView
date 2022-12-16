//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2022/12/14.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/ios/Desktop/WWProgressMaskView

import UIKit
import WWPrint
import WWProgressMaskView

final class ViewController: UIViewController {

    @IBOutlet weak var firstMaskView: WWProgressMaskView!
    @IBOutlet weak var secondMaskView: WWProgressMaskView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    private var firstPercent = 0        // 百分比的值 (1 / 100)
    private var secondBasisPoint = 0    // 萬分比的值 (1 / 10000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WWProgressMaskView"
        secondMaskView.setting(originalAngle: 90, lineWidth: 20, clockwise: false, lineCap: .round, innerImage: nil, outerImage: nil)
    }
    
    @IBAction func firstTestAction(_ sender: UIBarButtonItem) {
        firstLabel.text = "\(firstPercent) %"
        firstMaskView.progressCircle(progressUnit: .percent(firstPercent))
        firstPercent += 10
    }
    
    @IBAction func secondTestAction(_ sender: UIBarButtonItem) {
        secondLabel.text = "\(CGFloat(secondBasisPoint) / 100.0) %"
        secondMaskView.progressCircle(progressUnit: .basisPoint(secondBasisPoint))
        secondBasisPoint += 125
    }
}
