// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Siren",
    platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [.library(name: "Siren", targets: ["Siren"])],
    targets: [.target(name: "Siren", path: "Sources")],
    swiftLanguageVersions: [.v5]
)
