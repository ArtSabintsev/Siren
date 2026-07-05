// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Siren",
    platforms: [.iOS(.v17), .tvOS(.v17)],
    products: [.library(name: "Siren", targets: ["Siren"])],
    targets: [.target(name: "Siren", path: "Sources", resources: [.copy("Siren.bundle"), .copy("PrivacyInfo.xcprivacy")])],
    swiftLanguageVersions: [.v5]
)
