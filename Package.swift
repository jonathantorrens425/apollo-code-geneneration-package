// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApolloCodeGenerationPackage",
    platforms: [.macOS(.v12)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", exact: .init(stringLiteral: "1.0.6")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "ApolloCodeGenerationPackage",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ApolloCodegenLib", package: "apollo-ios"),
            ]),
        .executableTarget(
            name: "generate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ApolloCodegenLib", package: "apollo-ios"),
            ]
        ),
        .target(
            name: "GenerateCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ApolloCodegenLib", package: "apollo-ios"),
        ]),
    ]
)
