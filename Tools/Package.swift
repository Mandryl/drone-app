// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "ImportSDKDemoTools",
  dependencies: [
    .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.23.1"),
    .package(url: "https://github.com/toshi0383/xcconfig-extractor.git", from: "0.5.0"),
    .package(url: "https://github.com/uber/mockolo.git", from: "1.4.1"),
  ],
  targets: [.target(name: "ImportSDKDemoTools", path: "")]
)
