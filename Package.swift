// swift-tools-version:5.2.0

import PackageDescription

let package = Package(
    name: "VaporLugos",
    platforms: [
        .macOS(.v10_15),
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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(name: "Html", url: "https://github.com/tikimcfee/swift-html", from: "0.3.1"),
        .package(name: "MarkdownKit", url: "https://github.com/tikimcfee/swift-markdownkit", from: "1.0.5"),
        .package(name: "CSS", url: "https://github.com/tikimcfee/swift-css", .branch("master")),
    ],
    targets: [
        .target(
            name: "StylesData",
            dependencies: [
                "MarkdownKit",
                "Html",
                "CSS",
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
        .target(
            name: "Run",
            dependencies: [
                .target(name: "App"),
            ]
        ),
        .target(
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
