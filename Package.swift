// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Siren",
    platforms: [
        .iOS(.v11), 
        .tvOS(.v11)
    ],
    products: [
        .library(name: "Siren", targets: ["Siren"])
    ],
    targets: [
        .target(
            name: "Siren", 
            path: "Sources", 
            resources: [.copy("Siren.bundle")])
    ],
    swiftLanguageVersions: [.v5]
)
