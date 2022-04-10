// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TrackupVersionHistory",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TrackupVersionHistory", targets: ["TrackupVersionHistory"])
    ],
    dependencies: [
        .package(path: "../Trackup-Project")
    ],
    targets: [
        .target(
            name: "TrackupVersionHistory",
            dependencies: [
                .product(name: "TrackupCore", package: "Trackup-Project")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
