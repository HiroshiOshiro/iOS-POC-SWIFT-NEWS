# iOS-POC-SWIFT-NEWS

iOS 15+ / Swift / SwiftUI / MVVM のPOCアプリ。
[Now in Android](https://github.com/android/nowinandroid) のアーキテクチャ・モジュール構成をiOS(SPMローカルパッケージ)で再現している。

## 構成

- **News タブ**: Hacker News API から記事一覧を取得、お気に入り登録
- **お気に入り タブ**: Core Data に保存したお気に入り記事の一覧・詳細(ストリームで自動更新)
- **Setting タブ**: メールアドレス/パスワードでのログイン(モックAPI)、ログイン成功後のユーザー情報表示

## モジュール構成(NiA対応)

| このプロジェクト | Now in Android | 内容 |
|---|---|---|
| `Packages/Sources/CoreModel` | `core:model` | 依存ゼロの共有モデル |
| `Packages/Sources/CoreNetwork` | `core:network` | NetworkService / DataSource(protocol+Default実装) / DTO |
| `Packages/Sources/CoreDatabase` | `core:database` | Core Dataスタック(インメモリテスト対応) |
| `Packages/Sources/CoreDataStore` | `core:datastore` | UserDefaultsによる軽量な設定永続化 |
| `Packages/Sources/CoreRepository` | `core:data` | Repositoryプロトコル+実装+Mapper ※`CoreData`はAppleのフレームワーク名と衝突するため |
| `Packages/Sources/CoreDesignSystem` | `core:designsystem` | テーマ・atomレベルの共通コンポーネント(FavoriteButton等) |
| `Packages/Sources/CoreUI` | `core:ui` | 複数Featureで共有する複合UI(記事詳細・行) |
| `Packages/Sources/CoreTesting` | `core:testing` | Fake実装(テストターゲット専用) |
| `Packages/Sources/Feature*` | `feature:*` | News / Favorites / Settings |
| `iOS-POC-SWIFT-NEWS/App` | `app` | エントリポイント・DI・タブ構成 |

依存方向はSPMのターゲット依存で強制:
`Feature* → CoreUI / CoreRepository → CoreNetwork / CoreDatabase / CoreDataStore / CoreModel`

NiAに合わせた設計判断:
- Repositoryのインターフェースはdata層(`CoreRepository`)に置き、Domain層を持たない
- UseCaseは作らず、ViewModelがRepositoryを直接呼ぶ(NiAではDomain層は任意)
- NetworkはDTOのみを返し、Repository実装がDomainモデルへマッピングする
- お気に入り・ログインセッションはNiAのFlow同様、`AsyncStream`で継続的に公開する(タブ間の反映に手動再取得が不要)
- ユーザー設定はUserDataRepository(data層)がUserDefaults(datastore層)をラップし、ViewがAppStorageを直接触らない
- Repository実装は`DefaultXxxRepository`、DataSourceは`DefaultXxxDataSource`と命名(NiAの`OfflineFirstNewsRepository`等の実装名パターンに合わせ、汎用的な"Impl"は使わない)

## 技術要素

- Swift Concurrency(async/await, `@MainActor`, `AsyncStream`)
- Network: Hacker News API (`https://hacker-news.firebaseio.com`)
- ログインAPI送信処理は `URLRequest`/`URLSession` を実装した上で `URLProtocol` によりモック化
- ローカルDB: Core Data(お気に入り記事の永続化。ユニットテストはインメモリストアを使用)
- UserDefaults: ログインセッションの永続化(UserDataRepository経由)

## セットアップ

```sh
xcodegen generate
open iOS-POC-SWIFT-NEWS.xcodeproj
```

## テスト

```sh
cd Packages
xcodebuild test -scheme AppPackages-Package -destination 'platform=iOS Simulator,name=iPhone 17'
```
