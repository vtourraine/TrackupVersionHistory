// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TrackupVersionHistory",
    defaultLocalization: "en",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "TrackupVersionHistory", targets: ["TrackupVersionHistory"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/vtourraine/Trackup.git",
            from: "0.1.0"
        )
    ],
    targets: [
        .target(
            name: "TrackupVersionHistory",
            dependencies: [
                .product(name: "TrackupCore", package: "Trackup")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
