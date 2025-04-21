// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PyWrap",
    platforms: [.macOS(.v14), .iOS(.v17), .linux],
    products: [
        .library(name: "PyWrapRuntime", targets: ["PyWrapRuntime"]),
        .library(name: "RWrapRuntime", targets: ["RWrapRuntime"]),
        .plugin(name: "PyWrapGenerator", targets: ["PyWrapGenerator"]),
        .plugin(name: "RWrapGenerator", targets: ["RWrapGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        .target(name: "PyWrapRuntime", dependencies: ["PythonKit"]),
        .macro(name: "PyWrapMacro",
               dependencies: [
                   "PyWrapRuntime",
                   .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
               ]),
        .plugin(name: "PyWrapGenerator", capability: .buildTool(), dependencies: []),
        .target(name: "RWrapRuntime", dependencies: ["CShims"]),
        .macro(name: "RWrapMacro",
               dependencies: [
                   "RWrapRuntime",
                   .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
               ]),
        .plugin(name: "RWrapGenerator", capability: .buildTool(), dependencies: []),
        .target(
            name: "CShims",
            path: "Sources/CShims",
            publicHeadersPath: ".",
            linkerSettings: [
                .unsafeFlags(["-lR"])
            ]),
        .executableTarget(
            name: "Example",
            dependencies: ["PyWrapRuntime", "RWrapRuntime"],
            path: "Sources/Example",
            plugins: ["PyWrapGenerator", "RWrapGenerator"]
        )
    ]
)
