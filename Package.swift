// swift-tools-version:5.3
// When used via SPM the minimum Swift version is 5.3 because we need support for resources

import Foundation
import PackageDescription

let package = Package(
    name: "StreamChatSwiftUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(
            name: "StreamChatSwiftUI",
            targets: ["StreamChatSwiftUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/GetStream/stream-chat-swift.git", from: "4.5.0"),        
        .package(url: "https://github.com/kean/Nuke.git", from: "10.0.0"),
        .package(url: "https://github.com/kirualex/SwiftyGif.git", from: "5.3.0"),
        .package(url: "https://github.com/kean/NukeUI.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "StreamChatSwiftUI",
            dependencies: [.product(name: "StreamChat", package: "stream-chat-swift"), "Nuke", "SwiftyGif", "NukeUI"],
            exclude: ["README.md", "Info.plist", "Generated/L10n_template.stencil"],
            resources: [.process("Resources")]
        )
    ]
)