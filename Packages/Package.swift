// swift-tools-version: 5.9
import PackageDescription

// NowInAndroid のモジュール構成に対応:
//   CoreModel      = core:model      (依存ゼロの共有モデル)
//   CoreNetwork    = core:network    (DTOのみを扱い、Modelに依存しない)
//   CoreDatabase   = core:database   (Core Dataスタック)
//   CoreRepository = core:data       (Repositoryプロトコル+実装。"CoreData"はAppleのフレームワーク名と衝突するため)
//   CoreUI         = core:ui         (複数Featureで共有するUI)
//   Feature*       = feature:*
let package = Package(
    name: "AppPackages",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "CoreModel", targets: ["CoreModel"]),
        .library(name: "CoreNetwork", targets: ["CoreNetwork"]),
        .library(name: "CoreDatabase", targets: ["CoreDatabase"]),
        .library(name: "CoreRepository", targets: ["CoreRepository"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "FeatureNews", targets: ["FeatureNews"]),
        .library(name: "FeatureFavorites", targets: ["FeatureFavorites"]),
        .library(name: "FeatureSettings", targets: ["FeatureSettings"]),
    ],
    targets: [
        .target(name: "CoreModel"),
        .target(name: "CoreNetwork"),
        .target(
            name: "CoreDatabase",
            resources: [.process("Resources")]
        ),
        .target(
            name: "CoreRepository",
            dependencies: ["CoreModel", "CoreNetwork", "CoreDatabase"]
        ),
        .target(
            name: "CoreUI",
            dependencies: ["CoreModel", "CoreRepository"]
        ),
        .target(
            name: "FeatureNews",
            dependencies: ["CoreModel", "CoreRepository", "CoreUI"]
        ),
        .target(
            name: "FeatureFavorites",
            dependencies: ["CoreModel", "CoreRepository", "CoreUI"]
        ),
        .target(
            name: "FeatureSettings",
            dependencies: ["CoreModel", "CoreRepository"]
        ),
    ]
)
