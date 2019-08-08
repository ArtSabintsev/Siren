// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Siren",
    products: [.library(name: "Siren", targets: ["Siren"])],
    targets: [.target(name: "Siren", path: "Sources")]
)
