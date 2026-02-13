// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "TwentyFourHourClock",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .watchOS(.v10),
    .tvOS(.v17),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "TwentyFourHourClock",
      targets: ["TwentyFourHourClock"]
    ),
  ],
  targets: [
    .target(
      name: "TwentyFourHourClock"
    ),
  ]
)
