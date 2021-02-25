// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "VaporLugos",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
         .library(
            name: "VaporLugos",
            targets: [
                "VaporLugos"
            ]
         ),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // HTML DSL BBTTYLLOLKTHXBY
        .package(name: "Html", url: "https://github.com/pointfreeco/swift-html.git", from: "0.3.1"),
        // Markdown -> HTML
        .package(name: "Ink", url: "https://github.com/johnsundell/ink.git", from: "0.5.0"),
		// CSS STUFF!
        .package(name: "CSS", url: "https://github.com/tikimcfee/swift-css", .branch("master"))
    ],
    targets: [
        .target(
            name: "StylesData",
            dependencies: [
                "Ink",
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
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(
            name: "Run",
            dependencies: [
                .target(name: "App")
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
        )
    ]
)
