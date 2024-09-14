// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MasteringSwiftPM",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "FetchingViewFeature",
            targets: ["FetchingViewFeature"]
        ),
        .library(
            name: "BookListFeature",
            targets: ["BookListFeature"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(
                from: "5.0.0"
            )
        ),
        .package(
            url: "https://github.com/ratnesh-jain/AssetPluginLibrary",
            .upToNextMajor(
                from: "0.0.5"
            )
        )
    ],
    targets: [
        .target(name: "Resources"),
        .target(
            name: "Fonts",
            resources: [.process("Playwrite.ttf")]
        ),
        .target(name: "PersistentModels"),
        .target(
            name: "FetchingViewFeature",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                "Resources",
                "Fonts"
            ]
        ),
        .target(
            name: "BookListFeature",
            dependencies: ["PersistentModels"]
        ),
        .testTarget(
            name: "MasteringSwiftPMTests",
            dependencies: ["FetchingViewFeature"]
        ),
    ]
)

package.targets.forEach{
    $0.swiftSettings = [.enableUpcomingFeature("StrictConcurrency")]
}
