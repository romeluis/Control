// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Control",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Control",
            targets: ["Control"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/davedelong/DDMathParser.git", .upToNextMajor(from: "3.1.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Control",
            dependencies: [
                .product(name: "MathParser", package: "DDMathParser"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        
    ]
)
