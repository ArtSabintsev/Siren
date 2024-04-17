// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Siren",
    platforms: [.iOS(.v13), .tvOS(.v13)],
    products: [
        .library(
            name: "Siren",
            targets: ["Siren"]
        )
    ],
    targets: [
        .target(
            name: "Siren",
            path: "Sources",
            resources: [.copy("Siren.bundle")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
