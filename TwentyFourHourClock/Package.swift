// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "TwentyFourHourClock",
  platforms: [
    .macOS(.v26),
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
