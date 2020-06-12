// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Siren",    
    products: [.library(name: "Siren", targets: ["Siren"])],
    targets: [.target(name: "Siren", path: "Sources")],
    platforms: [.iOS(.v8)],  
    swiftLanguageVersions: [.v5]
)
