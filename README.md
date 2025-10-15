# WWProgressMaskView

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWProgressMaskView) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- The progress ring function of the custom background image uses the principle of picture shielding to make the color of the progress ring more diverse...
- 自訂背景圖的進度環功能，利用圖片遮罩的原理，讓進度環的色彩更多樣化…

![](./Example.webp)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWProgressMaskView.git", .upToNextMajor(from: "1.4.1"))
]
```

![](./IBDesignable.png)

### [Function - 可用函式](https://ezgif.com/video-to-webp)
|函式|功能|
|-|-|
|setting(originalAngle:lineWidth:clockwise:hiddenMarkerView:lineCap:lineGap:innerImage:outerImage:markerImage:innerStartAngle:innerEndAngle:)|設定一些初始值 => 會重畫|
|progressCircle(type:from:to:)|畫進度條 (以角度為準)|
|progressCircle(type:progressUnit:)|畫進度條|

### WWProgressMaskViewDelegate
|函式|功能|
|-|-|
|progressMaskViewAngle(_:from:to:)|進度條的移動角度|

### Example
```swift
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
```
