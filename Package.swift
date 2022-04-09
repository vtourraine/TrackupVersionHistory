// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TrackupReleaseNotes",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TrackupReleaseNotes", targets: ["TrackupReleaseNotes"])
    ],
    dependencies: [
        .package(path: "../Trackup-Project")
    ],
    targets: [
        .target(
            name: "TrackupReleaseNotes",
            dependencies: [
                .product(name: "TrackupCore", package: "Trackup-Project")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
