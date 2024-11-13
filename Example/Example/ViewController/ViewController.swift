//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2022/12/14.
//  ~/Library/Caches/org.swift.swiftpm/
//

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
        initSetting()
    }
    
    @IBAction func firstTestAction(_ sender: UIBarButtonItem) {
        firstPercent += 10
        firstLabel.text = "\(firstPercent) %"
        firstMaskView.progressCircle(progressUnit: .percent(firstPercent))
    }
    
    @IBAction func secondTestAction(_ sender: UIBarButtonItem) {
        secondBasisPoint += 1250
        secondLabel.text = "\(CGFloat(secondBasisPoint) / 100.0) %"
        secondMaskView.progressCircle(progressUnit: .basisPoint(secondBasisPoint))
    }
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        resetSetting()
    }
}

private extension ViewController {
    
    func initSetting() {
        self.title = "WWProgressMaskView"
        secondMaskView.setting(originalAngle: 225, lineWidth: 20, clockwise: false, lineCap: .round, lineGap: -18, innerStartAngle: 225, innerEndAngle: 495)
    }
        
    func resetSetting() {
        
        firstPercent = 0
        secondBasisPoint = 0
        
        secondLabel.text = "\(CGFloat(secondBasisPoint) / 100.0) %"
        firstLabel.text = "\(firstPercent) %"

        firstMaskView.progressCircle(progressUnit: .percent(firstPercent))
        secondMaskView.progressCircle(progressUnit: .basisPoint(secondBasisPoint))
    }
}
