// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Local",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "LocalAPI", targets: ["LocalAPI"]),
        .library(name: "Local", targets: ["Local"]),
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "LocalAPI",
            dependencies: [
                .product(name: "Domain", package: "Domain")
            ]
        ),
        .target(
            name: "Local",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                "LocalAPI"
            ],
            resources: [
                .process("Model/DataModel.xcdatamodeld")
            ],
        ),
    ]
)
