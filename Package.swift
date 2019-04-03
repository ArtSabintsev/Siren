// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Siren",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "Siren", targets: ["Siren"])
    ],
    targets: [
        .target(
            name: "Siren",
            path: "Sources"
        )
    ]
)
