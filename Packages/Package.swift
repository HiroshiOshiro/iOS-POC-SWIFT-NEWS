// swift-tools-version: 5.9
import PackageDescription

// NowInAndroid のモジュール構成に対応:
//   CoreModel        = core:model        (依存ゼロの共有モデル)
//   CoreNetwork      = core:network      (DTOのみを扱い、Modelに依存しない)
//   CoreDatabase     = core:database      (Core Dataスタック)
//   CoreDataStore    = core:datastore    (UserDefaultsによる軽量な設定永続化)
//   CoreRepository   = core:data          (Repositoryプロトコル+実装。"CoreData"はAppleのフレームワーク名と衝突するため)
//   CoreDesignSystem = core:designsystem (テーマ・atomレベルの共通コンポーネント)
//   CoreUI           = core:ui            (複数Featureで共有する複合UI)
//   CoreTesting      = core:testing       (Fake実装。テストターゲットのみが利用)
//   Feature*         = feature:*
//
// このブランチ(poc/factory)では、hmlongco/Factoryを使い
// Repositoryの解決をコンストラクタ注入からプロパティラッパー注入(@Injected)に変更している。
let package = Package(
    name: "AppPackages",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "CoreModel", targets: ["CoreModel"]),
        .library(name: "CoreNetwork", targets: ["CoreNetwork"]),
        .library(name: "CoreDatabase", targets: ["CoreDatabase"]),
        .library(name: "CoreDataStore", targets: ["CoreDataStore"]),
        .library(name: "CoreRepository", targets: ["CoreRepository"]),
        .library(name: "CoreDesignSystem", targets: ["CoreDesignSystem"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "CoreTesting", targets: ["CoreTesting"]),
        .library(name: "FeatureNews", targets: ["FeatureNews"]),
        .library(name: "FeatureFavorites", targets: ["FeatureFavorites"]),
        .library(name: "FeatureSettings", targets: ["FeatureSettings"]),
        .library(name: "FeatureNavigationDemo", targets: ["FeatureNavigationDemo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.4.0"),
    ],
    targets: [
        .target(name: "CoreModel"),
        .target(name: "CoreNetwork"),
        .target(
            name: "CoreDatabase",
            resources: [.process("Resources")]
        ),
        .target(name: "CoreDataStore"),
        .target(
            name: "CoreRepository",
            dependencies: [
                "CoreModel", "CoreNetwork", "CoreDatabase", "CoreDataStore",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .target(name: "CoreDesignSystem"),
        .target(
            name: "CoreUI",
            dependencies: [
                "CoreModel", "CoreRepository", "CoreDesignSystem",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .target(
            name: "CoreTesting",
            dependencies: ["CoreModel", "CoreNetwork", "CoreRepository"]
        ),
        .target(
            name: "FeatureNews",
            dependencies: [
                "CoreModel", "CoreRepository", "CoreUI",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .target(
            name: "FeatureFavorites",
            dependencies: [
                "CoreModel", "CoreRepository", "CoreUI",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .target(
            name: "FeatureSettings",
            dependencies: [
                "CoreModel", "CoreRepository",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .target(name: "FeatureNavigationDemo"),
        .testTarget(
            name: "CoreRepositoryTests",
            dependencies: ["CoreRepository", "CoreNetwork", "CoreDatabase", "CoreTesting"]
        ),
        .testTarget(
            name: "FeatureNewsTests",
            dependencies: [
                "FeatureNews", "CoreTesting",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .testTarget(
            name: "FeatureFavoritesTests",
            dependencies: [
                "FeatureFavorites", "CoreTesting",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .testTarget(
            name: "FeatureSettingsTests",
            dependencies: [
                "FeatureSettings", "CoreRepository", "CoreTesting",
                .product(name: "Factory", package: "Factory"),
            ]
        ),
    ]
)
