// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShowDetails",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ShowDetailsAPI", targets: ["ShowDetailsAPI"]),
        .library(name: "ShowDetails", targets: ["ShowDetails"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Service"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ShowDetailsAPI",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service")
            ]
        ),
        .target(
            name: "ShowDetails",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service"),
                "ShowDetailsAPI"
            ]
        ),
        .testTarget(
            name: "ShowDetailsTests",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service"),
                .product(name: "ServiceAPIMocks", package: "Service"),
                "ShowDetails",
                "ShowDetailsAPI"
            ]
        ),
    ]
)
