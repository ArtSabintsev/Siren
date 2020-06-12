// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Siren",
    swiftLanguageVersions: [.v5],
    defaultLocalization: LocalizationTag = nil,
    products: [.library(name: "Siren", targets: ["Siren"])],
    targets: [.target(name: "Siren", path: "Sources")]
)
