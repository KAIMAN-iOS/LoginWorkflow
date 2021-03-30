// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginWorkflow",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LoginWorkflow",
            targets: ["LoginWorkflow"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jerometonnelier/TextFieldEffects", .branch("master")),
        .package(url: "https://github.com/jerometonnelier/KCoordinatorKit", .branch("master")),
        .package(url: "https://github.com/jerometonnelier/ActionButton", .branch("master")),
        .package(url: "https://github.com/jerometonnelier/PhoneNumberKit", from: "4.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios", from: "3.2.1"),
        .package(name: "IQKeyboardManagerSwift", url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.0"),
        .package(url: "https://github.com/jerometonnelier/ATAConfiguration", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LoginWorkflow",
            dependencies: ["TextFieldEffects",
                           "KCoordinatorKit",
                           "PhoneNumberKit",
                           "ActionButton",
                           "IQKeyboardManagerSwift",
                           "SnapKit",
                           "ATAConfiguration",
                           "Lottie"])
    ]
)
