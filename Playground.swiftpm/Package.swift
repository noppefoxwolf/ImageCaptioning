// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Playground",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Playground",
            targets: ["AppModule"],
            bundleIdentifier: "40FE1958-F13F-425A-B5C3-54CDB052BCE8",
            teamIdentifier: "FBQ6Z8AF3U",
            displayVersion: "1.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .photoLibrary(purposeString: "Unknown Usage Description")
            ]
        )
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "ImageCaptioning", package: "ImageCaptioning")
            ],
            path: "."
        )
    ]
)