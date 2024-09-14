// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MasteringSwiftPMPackage",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MasteringSwiftPMPackage",
            targets: ["MasteringSwiftPMPackage"]),
        .library(name: "CommentsFeatureLibrary", targets: ["CommentsFeature"]),
        .library(name: "Resources", targets: ["Resources"]),
        .library(name: "CommentSwiftUIFeature", targets: ["CommentSwiftUIFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/ratnesh-jain/assetpluginlibrary", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "AppFonts", resources: [.process("Playwrite.ttf")]),
        .target(name: "Resources"),
        .target(name: "ServiceFeature"),
        .target(
            name: "MasteringSwiftPMPackage"),
        .target(
            name: "CommentsFeature",
            dependencies: ["ServiceFeature"]
        ),
        .target(
            name: "CommentSwiftUIFeature",
            dependencies: ["Resources", "ServiceFeature", "AppFonts"]
        ),
        .testTarget(
            name: "MasteringSwiftPMPackageTests",
            dependencies: ["MasteringSwiftPMPackage"]),
    ]
)
