// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Service",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ServiceAPI", targets: ["ServiceAPI"]),
        .library(name: "ServiceAPIMocks", targets: ["ServiceAPIMocks"]),
        .library(name: "Service", targets: ["Service"]),
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
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
        .target(
            name: "ServiceAPIMocks",
            dependencies: [
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
