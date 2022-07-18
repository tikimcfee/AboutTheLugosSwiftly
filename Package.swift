// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "VaporLugos",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "VaporLugos",
            targets: [
                "StylesData",
                "SharedAppTools",
                "VendorNetworking",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tikimcfee/swift-html", branch: "main"),
        .package(url: "https://github.com/tikimcfee/swift-css", branch: "master"),
        .package(url: "https://github.com/johnxnguyen/Down", branch: "master"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.62.1"),
    ],
    targets: [
        .target(
            name: "StylesData",
            dependencies: [
                .product(name: "Html", package: "swift-html"),
                .product(name: "CSS", package: "swift-css"),
            ]
        ),
        .target(
            name: "SharedAppTools"
        ),
        .target(
            name: "VendorNetworking"
        ),
        .target(
            name: "App",
            dependencies: [
                .product(name: "Down", package: "Down"),
                .product(name: "Vapor", package: "vapor"),
                .target(name: "StylesData"),
                .target(name: "SharedAppTools"),
                .target(name: "VendorNetworking"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
            ]
        ),
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "App"),
            ]
        ),
        .executableTarget(
            name: "Generators",
            dependencies: [
                .target(name: "StylesData"),
                .target(name: "SharedAppTools"),
                .target(name: "VendorNetworking"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ]
        ),
    ]
)
