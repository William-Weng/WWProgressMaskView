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

@IBDesignable
final class MyProgressMaskView: WWProgressMaskView {}

final class ViewController: UIViewController {

    @IBOutlet weak var firstMaskView: MyProgressMaskView!
    @IBOutlet weak var secondMaskView: MyProgressMaskView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    private var firstPercent = 0
    private var secondBasisPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func firstTestAction(_ sender: UIBarButtonItem) {
        firstLabel.text = "\(firstPercent) %"
        firstMaskView.progressCircle(progressUnit: .percent(firstPercent))
        firstPercent += 10
    }
    
    @IBAction func secondTestAction(_ sender: UIBarButtonItem) {
        secondLabel.text = "\(CGFloat(secondBasisPoint) / 100.0) %"
        secondMaskView.progressCircle(type: .once(0.25), progressUnit: .basisPoint(secondBasisPoint))
        secondBasisPoint += 1250
    }
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        resetSetting()
    }
}

extension ViewController: WWProgressMaskViewDelegate {
    
    func progressMaskViewAngle(_ progressMaskView: WWProgressMaskView, from startAngle: CGFloat, to endAngle: CGFloat) {
        wwPrint("\(progressMaskView) => from \(startAngle) to \(endAngle)")
    }
}

private extension ViewController {
    
    func initSetting() {
        self.title = "WWProgressMaskView"
        // secondMaskView.setting(originalAngle: 225, lineWidth: 20, clockwise: false, lineCap: .round, lineGap: -18, innerStartAngle: 225, innerEndAngle: 495)
        secondMaskView.setting(originalAngle: 135, lineWidth: 20, clockwise: true, hiddenMarkerView: false, lineCap: .round, lineGap: -18, markerImage: UIImage(named: "dollar"), innerStartAngle: 135, innerEndAngle: -135)
        secondMaskView.delegate = self
    }
        
    func resetSetting() {
        
        firstPercent = 0
        secondBasisPoint = 0
        
        secondLabel.text = "\(CGFloat(secondBasisPoint) / 100.0) %"
        firstLabel.text = "\(firstPercent) %"
        
        firstMaskView.progressCircle(progressUnit: .percent(firstPercent))
        secondMaskView.progressCircle(type: .once(0.25), progressUnit: .basisPoint(secondBasisPoint))
    }
}
