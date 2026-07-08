# iOS-POC-SWIFT-NEWS

iOS 15+ / Swift / SwiftUI / MVVM のPOCアプリ。
[Now in Android](https://github.com/android/nowinandroid) のアーキテクチャ・モジュール構成をiOS(SPMローカルパッケージ)で再現している。

## 構成

- **News タブ**: Hacker News API から記事一覧を取得、お気に入り登録
- **お気に入り タブ**: Core Data に保存したお気に入り記事の一覧・詳細
- **Setting タブ**: メールアドレス/パスワードでのログイン(モックAPI)、ログイン成功後のユーザー情報表示

## モジュール構成(NiA対応)

| このプロジェクト | Now in Android | 内容 |
|---|---|---|
| `Packages/Sources/CoreModel` | `core:model` | 依存ゼロの共有モデル |
| `Packages/Sources/CoreNetwork` | `core:network` | NetworkService / DataSource / DTO(Modelに依存しない) |
| `Packages/Sources/CoreDatabase` | `core:database` | Core Dataスタック |
| `Packages/Sources/CoreRepository` | `core:data` | Repositoryプロトコル+実装+Mapper ※`CoreData`はAppleのフレームワーク名と衝突するため |
| `Packages/Sources/CoreUI` | `core:ui` | 複数Featureで共有するUI(記事詳細・行) |
| `Packages/Sources/Feature*` | `feature:*` | News / Favorites / Settings |
| `iOS-POC-SWIFT-NEWS/App` | `app` | エントリポイント・DI・タブ構成 |

依存方向はSPMのターゲット依存で強制:
`Feature* → CoreUI / CoreRepository → CoreNetwork / CoreDatabase / CoreModel`

NiAに合わせた設計判断:
- Repositoryのインターフェースはdata層(`CoreRepository`)に置き、Domain層を持たない
- UseCaseは作らず、ViewModelがRepositoryを直接呼ぶ(NiAではDomain層は任意)
- NetworkはDTOのみを返し、Repository実装がDomainモデルへマッピングする

## 技術要素

- Swift Concurrency(async/await, `@MainActor`)
- Network: Hacker News API (`https://hacker-news.firebaseio.com`)
- ログインAPI送信処理は `URLRequest`/`URLSession` を実装した上で `URLProtocol` によりモック化
- ローカルDB: Core Data(お気に入り記事の永続化)
- AppStorage: ログインセッションの永続化

## セットアップ

```sh
xcodegen generate
open iOS-POC-SWIFT-NEWS.xcodeproj
```
