// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShowsList",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ShowsListAPI", targets: ["ShowsListAPI"]),
        .library(name: "ShowsList", targets: ["ShowsList"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Service"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ShowsListAPI",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service")
            ]
        ),
        .target(
            name: "ShowsList",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service"),
                "ShowsListAPI"
            ]
        ),
        .testTarget(
            name: "ShowsListTests",
            dependencies: [
                "ShowsList"
            ]
        ),
    ]
)
