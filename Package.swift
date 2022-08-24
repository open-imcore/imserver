// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static func paris(_ name: String) -> Target.Dependency {
        .product(name: name, package: "Paris")
    }
    
    static func barcelona(_ name: String) -> Target.Dependency {
        .product(name: name, package: "Barcelona")
    }
}

extension Package {
    func addingLibrary(name: String, dependencies: [Target.Dependency] = []) -> Package {
        products.append(.library(name: name, targets: [name]))
        targets.append(.target(name: name, dependencies: dependencies))
        return self
    }
}

extension Array {
    static func paris(_ names: String...) -> [Target.Dependency] {
        names.map { .paris($0) }
    }
    
    static func barcelona(_ names: String...) -> [Target.Dependency] {
        names.map { .barcelona($0) }
    }
}

let package = Package(
    name: "imserver",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .executable(name: "imserver", targets: ["imserver"])
    ],
    dependencies: [
//         Dependencies declare other packages that this package depends on.
//         .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Barcelona", url: "https://github.com/open-imcore/barcelona", .branchItem("spm")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMajor(from: "6.0.3")),
        .package(url: "https://github.com/EricRabil/Yammit", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/NozeIO/Noze.io", .upToNextMinor(from: "0.6.7"))
    ],
    targets: [
        .executableTarget(name: "imserver", dependencies: [
            .barcelona("Barcelona"), .barcelona("BarcelonaDB"), .barcelona("BarcelonaJS"), "SwiftCLI",  .product(name: "http", package: "Noze.io"), "Yammit"
        ])
    ]
)
