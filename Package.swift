// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWProgressMaskView",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "WWProgressMaskView", targets: ["WWProgressMaskView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWProgressMaskView", resources: [.process("Xib"), .process("Material")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
