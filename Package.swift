import PackageDescription

let versions = Version(0,0,0)..<Version(10,0,0)

let urls = [
    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
    "https://github.com/PerfectlySoft/Perfect-MySQL.git",
    "https://github.com/krzyzanowskim/CryptoSwift.git",
    "https://github.com/kylef/JSONWebToken.swift.git",
    "https://github.com/kylef/Stencil.git",
    "https://github.com/crossroadlabs/Markdown.git"
]

let package = Package(
    name: "OpenbuildWeb",
    targets: [
        Target(
            name: "RepositoryAuth",
            dependencies: ["OpenbuildExtensionCore", "OpenbuildMysql", "OpenbuildSingleton"]
        ),
        Target(
            name: "RouteAuth",
            dependencies: [
                "OpenbuildExtensionCore",
                "OpenbuildExtensionPerfect",
                "OpenbuildMysql",
                "OpenbuildRepository",
                "OpenbuildRouteRegistry",
                "OpenbuildSingleton"
            ]
        ),
        Target(
            name: "RouteStencil",
            dependencies: [
                "OpenbuildExtensionCore",
                "OpenbuildExtensionPerfect",
                "OpenbuildMysql",
                "OpenbuildRepository",
                "OpenbuildRouteRegistry",
                "OpenbuildSingleton",
                "RouteCMS"
            ]
        ),
        Target(
            name: "RouteCMS",
            dependencies: [
                "OpenbuildExtensionCore",
                "OpenbuildExtensionPerfect",
                "OpenbuildMysql",
                "OpenbuildRepository",
                "OpenbuildRouteRegistry",
                "OpenbuildSingleton"
            ]
        ),
        Target(name: "OpenbuildExtensionCore"),
        Target(
            name: "OpenbuildExtensionPerfect",
            dependencies: [
                "OpenbuildExtensionCore",
                "OpenbuildSingleton",
                "RepositoryAuth"
            ]
        ),
        Target(name: "OpenbuildMysql", dependencies: ["OpenbuildExtensionCore", "OpenbuildRepository"]),
        Target(
            name: "OpenbuildRepository"
        ),
        Target(
            name: "OpenbuildRouteRegistry",
            dependencies: [
                "OpenbuildExtensionPerfect"
            ]
        ),
        Target(name: "OpenbuildSingleton", dependencies: ["OpenbuildMysql", "OpenbuildRepository"]),
        Target(
            name: "Application",
            dependencies: [
                "RouteAuth",
                "RouteCMS",
                "RouteStencil",
                "OpenbuildExtensionCore",
                "OpenbuildExtensionPerfect",
                "OpenbuildSingleton",
                "OpenbuildMysql",
                "OpenbuildRouteRegistry",
                "OpenbuildRepository"
            ]
        )
    ],
    dependencies: urls.map { .Package(url: $0, versions: versions) }
)