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
    .package(url: "https://github.com/PaulWoodIII/CombineFeedback",
             Package.Dependency.Requirement._branchItem("add_tvos_watchos")),
    .package(url: "https://github.com/tcldr/Entwine", from: "0.6.0")
  ],
  targets: [
    .target(
      name: "LateralBusinessLogic",
      dependencies: [
        "CombineFeedback",
        "CombineFeedbackUI",
        "LateralCloudKit",
        "LateralCoreData",
        "LateralThinkingCore",
      ],
      path: "Sources/LateralBusinessLogic"),
    .target(
      name: "LateralCloudKit",
      dependencies: ["LateralThinkingCore"],
      path: "Sources/LateralCloudKit"),
    .target(
      name: "LateralCoreData",
      dependencies: ["LateralThinkingCore"],
      path: "Sources/LateralCoreData"),
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
    .testTarget(
      name: "LateralCoreDataTests",
      dependencies: [
        "LateralThinkingCore",
        "LateralCoreData",
        "Entwine",
        "EntwineTest",
    ]),
    .testTarget(
      name: "LateralCloudKitTests",
      dependencies: [
        "LateralThinkingCore",
        "LateralCloudKit",
        "Entwine",
        "EntwineTest"]),
    .testTarget(
      name: "LateralBusinessLogicTests",
      dependencies: [
        "LateralThinkingCore",
        "LateralBusinessLogic",
        "Entwine",
        "EntwineTest"]),
  ]
)
