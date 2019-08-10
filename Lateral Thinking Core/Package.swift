// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Lateral Thinking Core",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "LateralThinking",
      targets: ["LateralBusinessLogic"]),
  ],
  dependencies: [
    .package(url: "https://github.com/sergdort/CombineFeedback",
             Package.Dependency.Requirement._branchItem("master")),
    .package(url: "https://github.com/tcldr/Entwine",  Package.Dependency.Requirement._exactItem(Version(0, 7, 0)))
  ],
  targets: [
    .target(
      name: "LateralBusinessLogic",
      dependencies: [
        "CombineFeedback",
        "CombineFeedbackUI",
        "LateralCloudKit",
        "LateralThinkingCore",
      ],
      path: "Sources/LateralBusinessLogic"),
    .target(
      name: "LateralCloudKit",
      dependencies: ["LateralThinkingCore"],
      path: "Sources/LateralCloudKit"),
    .target(
      name: "LateralThinkingCore",
      dependencies: [],
      path: "Sources/LateralThinkingCore"),
    .testTarget(
      name: "LateralThinkingCoreTests",
      dependencies: [
        "LateralThinkingCore",
        "Entwine",
        "EntwineTest",
    ]),
  ]
)
