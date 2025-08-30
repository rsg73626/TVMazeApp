// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Service",
    products: [
        .library(name: "ServiceAPI", targets: ["ServiceAPI"]),
        .library(name: "Service", targets: ["Service"]),
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ServiceAPI",
            dependencies: [
                .product(name: "Domain", package: "Domain")
            ]
        ),
        .target(
            name: "Service",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                "ServiceAPI"
            ]
        ),
        .testTarget(
            name: "ServiceTests",
            dependencies: [
                "Service"
            ]
        ),
    ]
)
