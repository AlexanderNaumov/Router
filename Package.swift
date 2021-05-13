// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Router",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Router", targets: ["Router"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AlexanderNaumov/ReStore.git", .branch("no_when"))
    ],
    targets: [
        .target(name: "Router", dependencies: ["ReStore"], path: "Sources")
    ]
)
