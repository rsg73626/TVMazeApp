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
        .package(path: "../ShowDetails"),
    ],
    targets: [
        .target(
            name: "ShowsListAPI",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service"),
                .product(name: "ShowDetailsAPI", package: "ShowDetails")
            ]
        ),
        .target(
            name: "ShowsList",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "ServiceAPI", package: "Service"),
                .product(name: "ShowDetails", package: "ShowDetails"),
                .product(name: "ShowDetailsAPI", package: "ShowDetails"),
                "ShowsListAPI"
            ]
        ),
        .testTarget(
            name: "ShowsListTests",
            dependencies: [
                "ShowsList",
                .product(name: "ServiceAPI", package: "Service"),
                .product(name: "ServiceAPIMocks", package: "Service")
            ]
        ),
    ]
)
