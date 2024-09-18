// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-oauth-module",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "OauthModuleKit", targets: ["OauthModuleKit"]),
        .library(name: "OauthModule", targets: ["OauthModule"]),
        .library(name: "OauthModuleMigrationKit", targets: ["OauthModuleMigrationKit"]),
        .library(name: "OauthModuleDatabaseKit", targets: ["OauthModuleDatabaseKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.2"),
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/feather-framework/feather-push-driver-memory", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-database-driver-sqlite", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-module-kit", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.17.0")),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.1")),
        .package(url: "https://github.com/feather-framework/feather-access-control", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", .upToNextMinor(from: "5.0.0-rc.2")),
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMinor(from: "3.7.0")),

    ],
    targets: [
        .target(
            name: "OauthModuleKit",
            dependencies: [
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "FeatherModuleKit", package: "feather-module-kit"),
                .product(name: "SystemModuleKit", package: "feather-system-module"),
                .product(name: "FeatherACL", package: "feather-access-control"),
            ]
        ),
        .target(
            name: "OauthModuleDatabaseKit",
            dependencies: [
                .target(name: "OauthModuleKit"),
            ]
        ),
        .target(
            name: "OauthModule",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModule", package: "feather-system-module"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .target(name: "OauthModuleDatabaseKit"),
            ]
        ),

        .target(
            name: "OauthModuleMigrationKit",
            dependencies: [
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModuleMigrationKit", package: "feather-system-module"),
                .target(name: "OauthModuleDatabaseKit"),
            ]
        ),

        .testTarget(
            name: "OauthModuleKitTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "OauthModuleKit")
            ]
        ),

        .testTarget(
            name: "OauthModuleTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "OauthModule"),
                .target(name: "OauthModuleMigrationKit"),
                // drivers
                .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
                .product(name: "FeatherPushDriverMemory", package: "feather-push-driver-memory"),
                .product(name: "FeatherDatabaseDriverSQLite", package: "feather-database-driver-sqlite"),
            ]
        ),
    ]
)
