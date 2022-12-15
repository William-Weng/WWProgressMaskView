# WWProgressMaskView

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-13.0](https://img.shields.io/badge/iOS-13.0-pink.svg?style=flat)](https://developer.apple.com/swift/) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

The progress ring function of the custom background image uses the principle of picture shielding to make the color of the progress ring more diverse...

自訂背景圖的進度環功能，利用圖片遮罩的原理，讓進度環的色彩更多樣化…

![](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWProgressMaskView.git", .upToNextMajor(from: "1.0.0"))
]
```

![](./IBDesignable.png)

### Example
```swift
import UIKit
import WWPrint
import WWProgressMaskView

final class ViewController: UIViewController {

    @IBOutlet weak var firstMaskView: WWProgressMaskView!
    @IBOutlet weak var secondMaskView: WWProgressMaskView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    private var firstPercent = 0
    private var secondPercent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WWProgressMaskView"
        secondMaskView.setting(originalAngle: 90, lineWidth: 30, clockwise: false, lineCap: .round, innerImage: nil, outerImage: nil)
    }
    
    @IBAction func firstTestAction(_ sender: UIBarButtonItem) {
        firstLabel.text = "\(firstPercent) %"
        firstMaskView.progressCircle(percent: firstPercent)
        firstPercent += 10
    }
    
    @IBAction func secondTestAction(_ sender: UIBarButtonItem) {
        secondPercent += 5
        secondMaskView.progressCircle(percent: secondPercent)
        secondLabel.text = "\(secondPercent) %"
    }
}
```
