// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlphaPaywallVariants",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AlphaPaywallVariants",
            targets: ["AlphaPaywallVariants"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AlphaPaywallVariants",
            dependencies: ["SnapKit"]),
        .testTarget(
            name: "AlphaPaywallVariantsTests",
            dependencies: ["AlphaPaywallVariants"]),
    ]
)
