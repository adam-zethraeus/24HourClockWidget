// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "TwentyFourHourClock",
  platforms: [.macOS(.v13), .iOS(.v16)],
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
